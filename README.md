# dockers-layers

Demo repo for understanding OCI layers. To use this demo it is assumed that you are running Bash ~5, you have docker installed, and you have [dive](https://github.com/wagoodman/dive) installed.

## 00-from-scratch

Shows just about the simplest container you can have. It is based on the `scratch` image, which is a special image that is empty (it has no layers). You can't `RUN` anything as part of the build, since there are no binaries in it, but you can copy files into it. This would then be the only layer in the image.

## 01-naive-layers

This image is built from busybox and has several layers to it. There will be one layer for each `RUN` command in the Dockerfile. This is the most common way to build images, but it is not the most efficient. In particular, notice that "temporary" files still take up space, even when they are not accessible in the container itself. Also notice that when looking at the contents of the image layers, you can see `ENV` config as well as all of the commands from the dockerfile.

## 02-dense-layers

This image takes all the `RUN` commands from the previous image and collapses them into one `RUN` command. This is a more efficient way to build images, but in the layer content you can still see `ENV` config as well as all of the commands from the dockerfile.

## 03-multi-stage

This image grabs just the file that we need from the previous image and copies it to a new stage. The final image and it's layers have now reference to the temporary files or the `ENV` config from the "base" stage. Since we are using a multi-stage build though, we will want to leverage caching.

## 04-multi-stage-uncached

This image adds a `sleep` to show the effect of not caching finer grained layers in the first stage. Any changes to the first stage will break the cache and cause all commands of the first stage to be reran.

## 05-multi-stage-cached

Here the first stage is split up into finer grained layers. This will allow for caching of individual layers, so that only the layers after a change need to be rebuilt. This has the added benefit of making the image build easier to read and debug.
