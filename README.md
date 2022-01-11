# Simple Image Uploader

## Configurations

All configurations are passed to the app using ENV variables.
All ENV variables shown below are required.

```bash
ALLOWED_HOST=example.com,subdomain.example.com #complete domain (with subdomain) of the page where the images will be accessed (GET or via img tag)
FILE_INPUT_NAME=my_input # Value of the name attribute of the input feild of the file.
FILE_PATH=/path/to/storage/directory # path where the image will be stored on server
SALT=jhfgjsdg # A random salt used to create the image name.
SECRET=dfgdfgdfhfdh # A secret, used to vaildate POST request is from trusted server. Do not use the secret in the frontend, use the Allowed host to configure frontend usage.
```

I recommend using docker based deployment method as I have already created a docker image for this app. You will just have to -

1. pull the docker image
2. run the docker image with all the env variables.

### Docker Deployment Method

You can get the docker image by running the following command -

```bash
docker pull therohitdas/image-storage-app
```

Then you can run it by providing all the env variables.

Example:

```bash
sudo docker run \
 -e ALLOWED_HOST="localhost" \
 -e FILE_INPUT_NAME="my_image" \
 -e FILE_PATH="/var/www/html/images" \
 -e SALT="my_salt" \
 -e SECRET="my_secret_key" \
 -v image-storage:/var/www/html/images \
 -p 8080:80 \
 --name image-storage-app therohitdas/image-storage-app
```

## Usage

Once deployed, note the homepage url with correct PORT.

### Frontend Usage

If you have a simple form that sends image to the API, you can use the following code:

```html
<form
  method="POST"
  action="<full-url-to-the-image-storage-app>"
  enctype="multipart/form-data"
>
  <input type="file" name="<FILE_INPUT_NAME>" />
  <input type="text" value="<your unique 10 char long id>" name="id" />
  <!-- Optional, send an ID that you already use in your app -->
  <input type="submit" value="Upload" />
</form>
```

You need to replace `<full-url-to-the-image-storage-app>` with the url of the image storage app. Also you need to replace `<FILE_INPUT_NAME>` with the value you set for the FILE_INPUT_NAME while deploying the app.

Once successfully uploaded, it will return an id.

```json
{
  "id": "my_unique_id"
}
```

If you supplied an id, it will return the same id.
Else it will return the id that was generated.

You will need this id to access the images.

### Backend Usage

You can get the image uploaded first to your server then send a post request to the image-storage-app server with `SECRET` you set while deploying. This method will also return the id of the image.

## Accessing Images

If you add the following to the frontend page of any allowed HOST, you can access the images:

```html
<img
  src="<full-url-to-the-image-storage-app>/image.php?id=<id-returned-by-the-app>"
/>
```

The idea here is that you can use the id to access the image.

If you add cloudflare infront of the image-storage-server, make sure to add a page rule to cache everything with a very long TTL.
