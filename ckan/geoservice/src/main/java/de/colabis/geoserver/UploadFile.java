package de.colabis.geoserver;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.Consumes;
import javax.ws.rs.QueryParam;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.glassfish.jersey.media.multipart.FormDataContentDisposition;
import org.glassfish.jersey.media.multipart.FormDataParam;

@Path("/upload")
public class UploadFile {
    private String savePath = "";
    private String ipRange = "";
    private String key = "";

    @Context
    public void setServletContext(ServletContext context) {
        ipRange = String.valueOf(context.getInitParameter("AllowedIPRange"));
        if (context.getInitParameter("SavePath") == null)
            savePath = System.getProperty("java.io.tmpdir") + "/GeoserverUpload";
        else
            savePath = String.valueOf(context.getInitParameter("SavePath"));
        key = String.valueOf(context.getInitParameter("SecretKey"));
    }

    @GET
    @Path("/test")
    @Produces(MediaType.TEXT_PLAIN)
    public String getIt() {
        return "Everything seems to work!";
    }

    @GET
    @Path("/path")
    @Produces(MediaType.TEXT_PLAIN)
    public String getPath(@Context HttpServletRequest req, @QueryParam("key") String key) {
        if (is_authorization(req, key))
            return this.savePath;
        else
            return "[Error]: You are not authorized to use this!";
    }

    @POST
    @Path("/file")
    @Consumes({MediaType.MULTIPART_FORM_DATA})
    public Response uploadPdfFile(@Context HttpServletRequest req, @QueryParam("key") String key,
                                  @FormDataParam("file") InputStream fileInputStream,
                                  @FormDataParam("file") FormDataContentDisposition fileMetaData,
                                  @FormDataParam("foldername") String foldername) throws Exception {
        if (is_authorization(req, key)) {
            String UPLOAD_PATH = savePath + foldername + "/";
            try {
                String filename = fileMetaData.getFileName();
                if (filename.contains("/")) {
                    filename = filename.substring(filename.lastIndexOf("/") + 1, filename.length());
                }
                if (filename.contains("\\")) {
                    filename = filename.substring(filename.lastIndexOf("\\") + 1, filename.length());
                }
                int read;
                byte[] bytes = new byte[1024];

                Files.createDirectories(Paths.get(UPLOAD_PATH));
                OutputStream out = new FileOutputStream(new File(UPLOAD_PATH + filename));
                while ((read = fileInputStream.read(bytes)) != -1) {
                    out.write(bytes, 0, read);
                }
                out.flush();
                out.close();
            } catch (IOException e) {
                throw new WebApplicationException("Error while uploading file. Please try again !!");
            }
            return Response.ok("Data uploaded successfully !!").build();
        } else {
            return Response.ok("[Error]: You are not authorized to use this!").build();
        }
    }

    private boolean is_authorization(HttpServletRequest req, String inkey){
        Pattern pattern = Pattern.compile(this.ipRange);
        String ip = "";
        try {
            // if server is behind a proxy
            ip = req.getHeader("X-Forwarded-For").split(",")[0];
        } catch (Exception ignored) {
        }
        if (ip.equals("")) {
            // fallback, if no proxy is configured
            ip = req.getRemoteAddr();
        }
        Matcher matcher = pattern.matcher(ip);
        return matcher.matches() || this.key.equals(inkey);
    }
}
