require 'rubygems'
require 'RMagick'
require 'net/http'
require 'json'
require 'open-uri'
require 'logger'

module Owls
  class OwlGenerator
    OUTPUT_ENTITIES = ['&#9608;', '&#9619;', '&#9617;', "&nbsp;"]
    LOGGER = Logger.new STDOUT

    def initialize(size)
      @size = size
    end

    def generate_owl(url)
      LOGGER.debug "start image retrieval"
      img = fetch_image(url)

      LOGGER.debug "start image transform"
      img = transform_image(img)

      LOGGER.debug "start image translate"
      pixels = translate_image(img)

      LOGGER.debug "start image format"
      format_pixels(pixels, img.columns)
    rescue
      LOGGER.error "Something just went horribly wrong while parsing the image"
      return ""
    end

    private

    def fetch_image(url)
      LOGGER.debug "Open URL"
      file = open(url)

      img = Magick::ImageList.new
      LOGGER.debug "Read blob"
      img.from_blob(file.read)
    end

    def transform_image(img)
      # Owls tend to be brownish -> boost red and green channels
      img = img.normalize_channel(Magick::RedChannel)
      img = img.normalize_channel(Magick::GreenChannel)
      img = img.level_channel(Magick::RedChannel, black_point = 0, white_point = 50000, gamma = 2)
      img = img.level_channel(Magick::GreenChannel, black_point = 0, white_point = 50000, gamma = 2)

      # Reduce size and number of colors
      img = img.resize_to_fit(@size, @size)
      img = img.posterize(10)

      img = img.quantize(5, Magick::GRAYColorspace)
    end

    def translate_image(img)
      # Export image as list of pixels
      pixels = img.export_pixels(0, 0, img.columns, img.rows, 'I')

      # Find all unique pixel values
      values = {}
      pixels.group_by do |x|
        values[x] = 0 unless values.has_key? x
      end

      i = 0
      # assign rank/indices to found values
      values.keys.sort.each {|key| values[key] = i; i = i + 1 }

      # Map pixel rank to html entities.
      pixels.map { |pixel| OUTPUT_ENTITIES[values[pixel]] }
    end

    def format_pixels(pixels, width)
      str = ""
      pixels.each_slice(width) { |s| str = str + s.join + '\n'}
      str
    end
  end
end