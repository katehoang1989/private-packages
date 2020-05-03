module("luci.controller.filebrowser", package.seeall)

function index()
    page = entry({"admin", "services", "filebrowser"}, template("filebrowser"), _("File Browser"), 9997)
    page.i18n = "base"
    page.dependent = true

    page = entry({"admin", "services", "filebrowser_list"}, call("filebrowser_list"), nil)
    page.leaf = true

    page = entry({"admin", "services", "filebrowser_open"}, call("filebrowser_open"), nil)
    page.leaf = true

    page = entry({"admin", "services", "filebrowser_delete"}, call("filebrowser_delete"), nil)
    page.leaf = true

    page = entry({"admin", "services", "filebrowser_rename"}, call("filebrowser_rename"), nil)
    page.leaf = true

    page = entry({"admin", "services", "filebrowser_upload"}, call("filebrowser_upload"), nil)
    page.leaf = true
end

function list_response(path, success)
    luci.http.prepare_content("application/json")
    local result
    if success then
        local rv = scandir(path)
        result = {
            ec = 0,
            data = rv
        }
    else
        result = {
            ec = 1
        }
    end
    luci.http.write_json(result)
end

function filebrowser_list()
    local path = luci.http.formvalue("path")
    list_response(path, true)
end

function filebrowser_open()
    local path = luci.http.formvalue("path")
    local filename = luci.http.formvalue("filename")
    local io = require "io"
    local mime = to_mime(filename)

    file = path..filename

    local download_fpi = io.open(file, "r")
    luci.http.header('Content-Disposition', 'inline; filename="'..filename..'"' )
    luci.http.prepare_content(mime)
    luci.ltn12.pump.all(luci.ltn12.source.file(download_fpi), luci.http.write)
end

function filebrowser_delete()
    local path = luci.http.formvalue("path")
    local isdir = luci.http.formvalue("isdir")
    path = path:gsub("<>", "/")
    path = path:gsub(" ", "\ ")
    local success
    if isdir then
        success = os.execute('rm -r "'..path..'"')
    else
        success = os.remove(path)
    end
    list_response(nixio.fs.dirname(path), success)
end

function filebrowser_rename()
    local filepath = luci.http.formvalue("filepath")
    local newpath = luci.http.formvalue("newpath")
    local success = os.execute('mv "'..filepath..'" "'..newpath..'"')
    list_response(nixio.fs.dirname(filepath), success)
end

function filebrowser_upload()
    local filecontent = luci.http.formvalue("upload-file")
    local filename = luci.http.formvalue("upload-filename")
    local uploaddir = luci.http.formvalue("upload-dir")
    local filepath = uploaddir..filename

    local fp
    luci.http.setfilehandler(
        function(meta, chunk, eof)
            if not fp and meta and meta.name == "upload-file" then
                fp = io.open(filepath, "w")
            end
            if fp and chunk then
                fp:write(chunk)
            end
            if fp and eof then
                fp:close()
            end
      end
    )

    list_response(uploaddir, true)
end

function scandir(directory)
    local i, t, popen = 0, {}, io.popen

    local pfile = popen("ls -lh \""..directory.."\" | egrep '^d' ; ls -lh \""..directory.."\" | egrep -v '^d|^l'")
    for fileinfo in pfile:lines() do
        i = i + 1
        t[i] = fileinfo
    end
    pfile:close()
    pfile = popen("ls -lh \""..directory.."\" | egrep '^l' ;")
    for fileinfo in pfile:lines() do
        i = i + 1
        linkindex, _, linkpath = string.find(fileinfo, "->%s+(.+)$")
        local finalpath;
        if string.sub(linkpath, 1, 1) == "/" then
            finalpath = linkpath
        else
            finalpath = nixio.fs.realpath(directory..linkpath)
        end
        local linktype;
        if not finalpath then
            finalpath = linkpath;
            linktype = 'x'
        elseif nixio.fs.stat(finalpath, "type") == "dir" then
            linktype = 'z'
        else
            linktype = 'l'
        end
        fileinfo = string.sub(fileinfo, 2, linkindex - 1)
        fileinfo = linktype..fileinfo.."-> "..finalpath
        t[i] = fileinfo
    end
    pfile:close()
    return t
end

MIME_TYPES = {
    ["aac"]   = "audio/aac";
    ["abw"]   = "application/x-abiword";
    ["arc"]   = "application/x-freearc";
    ["avi"]   = "video/x-msvideo";
    ["azw"]   = "application/vnd.amazon.ebook";

    ["bin"]   = "application/octet-stream";
    ["bmp"]   = "image/bmp";
    ["bz"]   = "application/x-bzip";
    ["bz2"]   = "application/x-bzip2";

    ["csh"]   = "application/x-csh";
    ["css"]   = "text/css";
    ["csv"]   = "text/csv";

    ["doc"]   = "application/msword";
    ["docx"]   = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";

    ["eot"]   = "application/vnd.ms-fontobject";
    ["epub"]   = "application/epub+zip";

    ["gz"]   = "application/gzip";
    ["gif"]   = "image/gif";

    ["htm"]   = "text/html";
    ["html"]   = "text/html";

    ["ico"]   = "image/vnd.microsoft.icon";
    ["ics"]   = "text/calendar";

    ["jar"]   = "application/java-archive";
    ["jpeg"]   = "image/jpeg";
    ["jpg"]   = "image/jpeg";
    ["js"]   = "text/javascript";
    ["json"]   = "application/json";
    ["jsonld"]   = "application/ld+json";

    ["mid"]   = "audio/midi";
    ["mid"]   = "audio/x-midi";
    ["midi"]   = "audio/midi";
    ["midi"]   = "audio/x-midi";
    ["mjs"]   = "text/javascript";
    ["mp3"]   = "audio/mpeg";
    ["mp4"]   = "video/mp4";
    ["mpeg"]   = "video/mpeg";
    ["mpkg"]   = "application/vnd.apple.installer+xml";

    ["odp"]   = "application/vnd.oasis.opendocument.presentation";
    ["ods"]   = "application/vnd.oasis.opendocument.spreadsheet";
    ["odt"]   = "application/vnd.oasis.opendocument.text";
    ["oga"]   = "audio/ogg";
    ["ogv"]   = "video/ogg";
    ["ogx"]   = "application/ogg";
    ["opus"]   = "audio/opus";
    ["otf"]   = "font/otf";

    ["png"]   = "image/png";
    ["pdf"]   = "application/pdf";
    ["php"]   = "application/php";
    ["ppt"]   = "application/vnd.ms-powerpoint";
    ["pptx"]   = "application/vnd.openxmlformats-officedocument.presentationml.presentation";

    ["rar"]   = "application/vnd.rar";
    ["rtf"]   = "application/rtf";

    ["sh"]   = "application/x-sh";
    ["svg"]   = "image/svg+xml";
    ["swf"]   = "application/x-shockwave-flash";

    ["tar"]   = "application/x-tar";
    ["tif"]   = "image/tiff";
    ["tiff"]   = "image/tiff";
    ["ts"]   = "video/mp2t";
    ["ttf"]   = "font/ttf";
    ["txt"]   = "text/plain";

    ["vsd"]   = "application/vnd.visio";

    ["wav"]   = "audio/wav";
    ["weba"]   = "audio/webm";
    ["webm"]   = "video/webm";
    ["webp"]   = "image/webp";
    ["woff"]   = "font/woff";
    ["woff2"]   = "font/woff2";

    ["xhtml"]   = "application/xhtml+xml";
    ["xls"]   = "application/vnd.ms-excel";
    ["xlsx"]   = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
    ["xml"]   = "application/xml";
    ["xml"]   = "text/xml";
    ["xul"]   = "application/vnd.mozilla.xul+xml";

    ["zip"]   = "application/zip";

    ["3gp"]   = "video/3gpp";
    ["3gp"]   = "audio/3gpp";
    ["3g2"]   = "video/3gpp2";
    ["3g2"]   = "audio/3gpp2";

    ["7z"]   = "application/x-7z-compressed";
}

function to_mime(filename)
    if type(filename) == "string" then
        local ext = filename:match("[^%.]+$")

        if ext and MIME_TYPES[ext:lower()] then
            return MIME_TYPES[ext:lower()]
        end
    end

    return "application/octet-stream"
end
