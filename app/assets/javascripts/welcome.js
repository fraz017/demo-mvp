$(document).ready(function() {
    var latitude = 0.0;
    var longitude = 0.0;
    $(".overlay").hide();
    $(".alert").hide();
    var id = ""
    if (window.requestIdleCallback) {
        requestIdleCallback(function () {
            Fingerprint2.get({}, function (components) {
                var values = components.map(function (component) { return component.value })
                id = Fingerprint2.x64hash128(values.join(''), 31)

            })
        })
    } else {
        setTimeout(function () {
            Fingerprint2.get({}, function (components) {
                var values = components.map(function (component) { return component.value })
                id = Fingerprint2.x64hash128(values.join(''), 31)
            })
        }, 500)
    }

    if (navigator && navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(showPosition);
    } else {
        alert("error")
    }

    function showPosition(position) {
        latitude =  position.coords.latitude;
        longitude = position.coords.longitude;
    }

    // var fileInput = document.getElementById('file-input');

    // fileInput.addEventListener('change', (e) => {
    //     console.log(e.target.files)

    //     var file = e.target.files[0];

    //     if (file.type.match(/image.*/)) {
    //         console.log('An image has been loaded');

    //         // Load the image
    //         var reader = new FileReader();
    //         reader.onload = function (readerEvent) {
    //             var image = new Image();
    //             image.onload = function (imageEvent) {

    //                 // Resize the image
    //                 var canvas = document.createElement('canvas'),
    //                     max_size = 300,// TODO : pull max size from a site config
    //                     width = image.width,
    //                     height = image.height;
    //                 if (width > height) {
    //                     if (width > max_size) {
    //                         height *= max_size / width;
    //                         width = max_size;
    //                     }
    //                 } else {
    //                     if (height > max_size) {
    //                         width *= max_size / height;
    //                         height = max_size;
    //                     }
    //                 }
    //                 canvas.width = width;
    //                 canvas.height = height;
    //                 canvas.getContext('2d').drawImage(image, 0, 0, width, height);
    //                 var dataUrl = canvas.toDataURL('image/jpeg');
    //                 var resizedImage = dataURLToBlob(dataUrl);

    //                 $.event.trigger({
    //                     type: "imageResized",
    //                     blob: resizedImage,
    //                     url: dataUrl
    //                 });

    //             }
    //             image.src = readerEvent.target.result;
    //         }
    //         reader.readAsDataURL(file);
    //     }
    // });

    var mediaStream = null;


    $(function () {
        var image = $("#logo");
        $(".app__layout").hide();
        image.click(function () {
            $(".bg-lays").animate({
                width: "toggle"
            });
            $(".app__layout").show();
            if( /Android|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) { 
                var video = document.getElementById('video');
                var canvas = document.getElementById('canvas');
                var context = canvas.getContext('2d');
                // Get access to the camera!
                if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
                    // Not adding `{ audio: true }` since we only want video now 
                    navigator.mediaDevices.getUserMedia({ video: { facingMode: { exact: "environment" } } }).then(function (stream) {
                        //video.src = window.URL.createObjectURL(stream);
                        video.srcObject = stream;
                        video.play();
                        setTimeout(function () {
                            context.drawImage(video, 0, 0, 300, 300);
                            triggerCallback()
                        }, 3000);

                        mediaStream = stream;
                        mediaStream.stop = function () {
                            this.getAudioTracks().forEach(function (track) {
                                track.stop();
                            });
                            this.getVideoTracks().forEach(function (track) { //in case... :)
                                track.stop();
                            });
                        };
                    });
                }
                // Trigger photo take
            }
        });
    });

    if (/Android|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
        $(".scan-icon").show();
        $(".deskktop").hide();
    }
    else {
        $(".scan-icon").hide();
        $(".deskktop").show();
    }

    function triggerCallback() {
        var canvas = document.getElementById('canvas');
        var dataUrl = canvas.toDataURL('image/jpeg');
        var resizedImage = dataURLToBlob(dataUrl);

        $.event.trigger({
            type: "imageResized",
            blob: resizedImage,
            url: dataUrl
        });
    }

    var dataURLToBlob = function (dataURL) {
        var BASE64_MARKER = ';base64,';
        if (dataURL.indexOf(BASE64_MARKER) == -1) {
            var parts = dataURL.split(',');
            var contentType = parts[0].split(':')[1];
            var raw = parts[1];

            return new Blob([raw], { type: contentType });
        }

        var parts = dataURL.split(BASE64_MARKER);
        var contentType = parts[0].split(':')[1];
        var raw = window.atob(parts[1]);
        var rawLength = raw.length;

        var uInt8Array = new Uint8Array(rawLength);

        for (var i = 0; i < rawLength; ++i) {
            uInt8Array[i] = raw.charCodeAt(i);
        }

        return new Blob([uInt8Array], { type: contentType });
    }

    $(document).on("imageResized", function (event) {
        mediaStream.stop();
        // var data = new FormData($("form[id*='uploadImageForm']")[0]);
        $(".app__layout").animate({
            width: "toggle"
        });
        $(".bg-lays").show()
        if (event.blob && event.url) {
            var formData = new FormData();
            formData.append('id', id);
            formData.append('latitude', latitude);
            formData.append('longitude', longitude);
            formData.append('image', event.blob, 'filename.jpg');
            $(".overlay").show();
            $.ajax({
                url: '/recognize',
                type: 'POST',
                data: formData,
                contentType: false,
                processData: false,
                success: function (data) {
                    if (data.url) {
                        window.location.href = data.url;
                    }
                    else {
                        $(".overlay").hide();
                        $(".msg-alert").html(data.msg)
                        $(".msg-alert").fadeIn(300).delay(2500).fadeOut(400);
                    }
                },
                error: function (data) {
                    $(".overlay").hide();
                }
            });
        }
    });

})