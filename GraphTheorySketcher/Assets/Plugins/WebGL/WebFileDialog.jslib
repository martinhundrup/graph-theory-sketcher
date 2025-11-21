mergeInto(LibraryManager.library, {
    DownloadFile: function (fileNamePtr, mimeTypePtr, contentPtr) {
        var fileName = UTF8ToString(fileNamePtr);
        var mimeType = UTF8ToString(mimeTypePtr);
        var content  = UTF8ToString(contentPtr);

        var blob = new Blob([content], { type: mimeType || "text/plain" });
        var url  = window.URL.createObjectURL(blob);

        var a = document.createElement("a");
        a.href = url;
        a.download = fileName || "download.txt";
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);

        window.URL.revokeObjectURL(url);
    },

    UploadFile: function (gameObjectNamePtr, methodNamePtr, acceptPtr) {
        var goName     = UTF8ToString(gameObjectNamePtr);
        var methodName = UTF8ToString(methodNamePtr);
        var accept     = UTF8ToString(acceptPtr);

        var input = document.createElement("input");
        input.type = "file";
        if (accept) {
            input.accept = accept;  // example ".gts,.json,.txt"
        }
        input.style.display = "none";

        input.addEventListener("change", function (event) {
            var file = event.target.files[0];
            if (!file) {
                document.body.removeChild(input);
                return;
            }

            var reader = new FileReader();
            reader.onload = function (e) {
                var text = e.target.result;
                SendMessage(goName, methodName, text);
                document.body.removeChild(input);
            };
            reader.readAsText(file);
        });

        document.body.appendChild(input);
        input.click();
    }
});
