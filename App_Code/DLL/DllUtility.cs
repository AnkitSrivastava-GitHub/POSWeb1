using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;

namespace DllUtility
{
    public class Utility
    {
        public int Opcode { get; set; }
        public int StoreId { get; set; }
        public DataSet Ds;
        public int Action { get; set; }
        public string exceptionMessage { get; set; }
        public bool isException { get; set; }
        public string responseCode { get; set; }
        public int PageIndex { get; set; }
        public int PageSize = 10;
        public int TerminalId { get; set; }
        public bool RecordCount { get; set; }
        public string IPAddress { get; set; }
        public int Who { get; set; }
    }
    public class Config
    {
        public SqlConnection con;
        public Config()
        {
            string host = HttpContext.Current.Request.Url.Host;
            string conString = "";
            if (host == "localhost")
            {
                conString = @"Data Source=EDORO_TECH\SQLEXPRESS01; Initial Catalog=pos101.priorpos.com; Integrated Security=True; connect timeout=1800000;";
            }
            else
            {
                //conString = @"Data Source=MYWAYP; User Id=sa; Password=mwp@2021#; Initial Catalog=" + host + "; connect timeout=1800000;";
            }
            con = new SqlConnection(conString);
        }

    }
    public class gZipCompression
    {
        public static void fn_gZipCompression()
        {
            HttpResponse Response = HttpContext.Current.Response;
            string AcceptEncoding = HttpContext.Current.Request.Headers["Accept-Encoding"];
            if (AcceptEncoding.Contains("gzip"))
            {
                Response.Filter = new System.IO.Compression.GZipStream(Response.Filter,
                                          System.IO.Compression.CompressionMode.Compress);
                Response.AppendHeader("Content-Encoding", "gzip");
            }
            else
            {
                Response.Filter = new System.IO.Compression.DeflateStream(Response.Filter,
                                          System.IO.Compression.CompressionMode.Compress);
                Response.AppendHeader("Content-Encoding", "deflate");
            }
        }
    }
    public static class Globals
    {
        public static string UserName;
        public static string UserId;
        public static string UserType;
        public static string Name;
        public static int Terminal;
        public static string Mode;
        public static int BalanceMasterAutoId;
        public static string Company;
    }
}
