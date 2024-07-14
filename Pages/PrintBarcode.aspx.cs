using System;
using System.IO;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;

public partial class Pages_PrintBarcode : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["EmpAutoId"] == null)
        {
            Session.Abandon();
            Response.Redirect("~/Default.aspx", false);
        }
        else
        {
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/PrintBarcode.js"));
            Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
        }
    }

    [WebMethod]
    public static string CurrencySymbol()
    {
        string CurrencySymbol = "";
        if (System.Web.HttpContext.Current.Session["CurrencySymbol"] != null)
        {

            CurrencySymbol = Convert.ToString(HttpContext.Current.Session["CurrencySymbol"]);

            return CurrencySymbol;
        }
        else
        {
            return "Session";
        }
    }

    [WebMethod]
    public static string MultiBarcode(string ProductId)
    {
        global::DLLPrintBarcode.PL_PrintBarcode pobj = new global::DLLPrintBarcode.PL_PrintBarcode();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.ProductId = Convert.ToInt32(ProductId);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);

                global::DLLPrintBarcode.BAL_PrintBarcode.MultiPackingBarcode(pobj);
                if (pobj.isException != true)
                {
                    return pobj.Ds.GetXml();
                    //return "true";
                }
                else
                {
                    return pobj.exceptionMessage.ToString();
                }

            }
            else
            {
                return "Session";
            }
        }
        catch (Exception ex)
        {
            pobj.isException = true;
            return pobj.exceptionMessage = ex.Message;
        }
    }

    [WebMethod]
    public static string AddinList(string ProductId)
    {        
        global::DLLPrintBarcode.PL_PrintBarcode pobj = new global::DLLPrintBarcode.PL_PrintBarcode();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.ProductId = Convert.ToInt32(ProductId);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                
                global::DLLPrintBarcode.BAL_PrintBarcode.AddinList(pobj);
                if (pobj.isException != true)
                {
                    return pobj.Ds.GetXml();
                    //return "true";
                }
                else
                {
                    return pobj.exceptionMessage.ToString();
                }

            }
            else
            {
                return "Session";
            }
        }
        catch (Exception ex)
        {
            pobj.isException = true;
            return pobj.exceptionMessage = ex.Message;
        }
    }
}