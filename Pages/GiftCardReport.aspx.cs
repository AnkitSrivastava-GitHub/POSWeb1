using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.Services;
using System.Web.Script.Serialization;

public partial class Pages_GiftCardReport : System.Web.UI.Page
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
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/GiftCardReport.js"));
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

    [WebMethod(EnableSession = true)]
    public static string BindGiftCard(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        global::DLLGiftCardReport.PL_GiftCarddetail pobj = new global::DLLGiftCardReport.PL_GiftCarddetail();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Store = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.InvoiceAutoId = Convert.ToInt32(jdv["InvoiceAutoId"]);
                pobj.Terminal = Convert.ToInt32(jdv["Terminal"]);
                pobj.Mobile = jdv["Mobile"];
                if (jdv["FromDate"] != "")
                {
                    pobj.FromDate = Convert.ToDateTime(jdv["FromDate"]);
                }
                if (jdv["ToDate"] != "")
                {
                    pobj.ToDate = Convert.ToDateTime(jdv["ToDate"]);
                }
                pobj.CustomerName = jdv["CustomerName"];
                pobj.Status = Convert.ToInt32(jdv["Status"]);
                pobj.Email = jdv["Email"];
                pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                DLLGiftCardReport.BAL_GiftCarddetail.BindGiftCard(pobj);
                if (pobj.isException != true)
                {
                    return pobj.Ds.GetXml();
                    //return "true";
                }
                else
                {
                    return "false";
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
            pobj.exceptionMessage = ex.Message;
            return "false";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string BindGiftCardSearch(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        global::DLLGiftCardReport.PL_GiftCarddetail pobj = new global::DLLGiftCardReport.PL_GiftCarddetail();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Store = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.InvoiceAutoId = Convert.ToInt32(jdv["InvoiceAutoId"]);
                pobj.Mobile = jdv["Mobile"];
                pobj.GiftCode = jdv["GiftCode"];
                pobj.Email = jdv["Email"];
                pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                DLLGiftCardReport.BAL_GiftCarddetail.BindGiftCardSearch(pobj);
                if (pobj.isException != true)
                {
                    return pobj.Ds.GetXml();
                    //return "true";
                }
                else
                {
                    return "false";
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
            pobj.exceptionMessage = ex.Message;
            return "false";
        }
    }
}