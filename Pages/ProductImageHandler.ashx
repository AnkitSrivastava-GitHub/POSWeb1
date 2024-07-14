<%@ WebHandler Language="C#" Class="ProductImageHandler" %>

using System;
using System.Web;
using System.IO;
using System.Data;
using Newtonsoft.Json;

public class ProductImageHandler : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        try
        {
            string timeStamp = context.Request.QueryString["timestamp"].ToString();
            //string from = context.Request.QueryString["From"].ToString();
            string fname = "";
            string fnameCopy = "";

            DataTable dt = new DataTable();
            DataRow dtRow;
            dt.Columns.Add("URL");

            //string arr_images = "[{}";

            if (context.Request.Files.Count > 0)
            {
                #region image
                HttpFileCollection files = context.Request.Files;
                for (int i = 0; i < files.Count; i++)
                {
                    HttpPostedFile file = files[i];
                    if (HttpContext.Current.Request.Browser.Browser.ToUpper() == "IE" || HttpContext.Current.Request.Browser.Browser.ToUpper() == "INTERNETEXPLORER")
                    {
                        string[] testfiles = file.FileName.Split(new char[] { '\\' });
                        fname = testfiles[testfiles.Length - 1];
                    }
                    else
                    {
                        fname = file.FileName;
                    }
                    fname = timeStamp + "_" + fname;

                    dtRow = dt.NewRow();
                    dtRow["URL"] = fname;
                    dt.Rows.Add(dtRow);
                    fnameCopy = fname;
                    fname = Path.Combine(context.Server.MapPath("~/Images/ProductImages"), fname);
                    file.SaveAs(fname);
                }
                #endregion
                //arr_images += "]";
            }
            context.Response.ContentType = "text/plain";
            //context.Response.Write(arr_images.Replace("{},", ""));
            context.Response.Write(JsonConvert.SerializeObject(dt));
            HttpContext.Current.Response.StatusCode = 200;
        }
        catch (Exception ex)
        {
            context.Response.ContentType = "text/plain";
            context.Response.Write(ex.Message);
            HttpContext.Current.Response.StatusCode = 400;
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}