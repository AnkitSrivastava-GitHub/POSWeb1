<%@ WebHandler Language="C#" Class="UploadPackingImage" %>

using System;
using System.Web;
using System.IO;

public class UploadPackingImage : IHttpHandler {
    public void ProcessRequest(HttpContext context)
    {
        try
        {
            string fileReName = "";
            HttpFileCollection files = context.Request.Files;
            if (context.Request.Files.Count > 0)
            {
                for (int i = 0; i < files.Count; i++)
                {
                    HttpPostedFile file = files[i];
                    string Img = file.FileName;
                    var ext = Path.GetExtension(file.FileName);
                    var fileNameWithoutExt = Path.GetFileNameWithoutExtension(file.FileName);
                    //fileReName = Guid.NewGuid().ToString("N") + "_" + Imgame.Replace(" ", "_").ToString();
                    fileReName = Guid.NewGuid().ToString("N")+ext;
                    var fullFileNameWithPath=context.Server.MapPath("~/Images/ProductImages/") +fileReName ;
                    file.SaveAs(fullFileNameWithPath);
                }
                context.Response.ContentType = "text/plain";
                context.Response.Write(fileReName);
                //context.Response.StatusCode = 100;
            }
            else
            {
                context.Response.ContentType = "text/plain";
                context.Response.Write("Failed");
                //context.Response.StatusCode = 300;
            }
        }
        catch (Exception ex)
        {
            context.Response.ContentType = "text/plain";
            context.Response.Write("Failed");
            //context.Response.StatusCode = 400;
        }

    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}