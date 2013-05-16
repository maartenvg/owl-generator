Owl Generator
=============

Little Sinatra app to randomly generate ASCII-art from owls, based on images found via Bing's image search API.

Run by running
    
    ruby controller.rb
    
Or placing it in your Rack setup.

Call `http://YOUR-SERVER/random/100` where the `100` refers to the maximum size.

This will give you a JSON string with the original URL and the resulting 'image' of html entities for 
the different shades of gray.

```
{
  original: 'http://url-to-original/image.jpg',
  image: '...'
}
```

It is recommended to put the image in a <pre> block or use a monospaced font.
