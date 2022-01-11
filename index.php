<h1>Simple Image Upload Solution</h1>
<form method="POST" action="image.php" enctype="multipart/form-data">
    <input type="file" name="my_image" />
    <input type="text" name="secret" value="super_secret" style="display:none">
    <input type="submit" value="Upload" />
</form>
<p>
    <a href="https://github.com/therohitdas/image-storage-php">Download the source code or Dockerfile</a>
</p>

<p>
    <input id="id" type="text" placeholder="enter the id to display image">
    <br>
    <button id="show" style="margin-top: 10px;">Show Image</button>
</p>

<script>
    var id = document.getElementById("id");
    var show = document.getElementById("show");
    show.addEventListener("click", function() {
        //  add an image tag with the image url
        var img = document.createElement("img");
        img.src = "image.php?id=" + id.value;
        img.style.margin = "20px auto";
        document.body.appendChild(img);
    });
</script>