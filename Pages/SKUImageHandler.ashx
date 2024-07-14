<%@ WebHandler Language="C#" Class="SKUImageHandler" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using System.IO;

public class SKUImageHandler : IHttpHandler {
    
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
                    string Imgame = file.FileName;
                    var ext = Path.GetExtension(file.FileName);
                    var fileNameWithoutExt = Path.GetFileNameWithoutExtension(file.FileName);
                    fileReName = Guid.NewGuid().ToString("N") + "_" + Imgame.Replace(" ", "_").ToString();
                    var fullFileNameWithPath=context.Server.MapPath("~/Images/ProductImages/") +fileReName ;
                    file.SaveAs(fullFileNameWithPath);
                }
                context.Response.ContentType = "text/plain";
                context.Response.Write(fileReName);
            }
            else
            {
                context.Response.ContentType = "text/plain";
                context.Response.Write("Failed");
            }
        }
        catch (Exception ex)
        {
            context.Response.ContentType = "text/plain";
            context.Response.Write("Failed");
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }
}