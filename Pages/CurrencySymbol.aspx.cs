using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_CurrencySymbol : System.Web.UI.Page
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
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/CurrencySymbol.js"));
            Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
        }
    }
    [WebMethod]
    public static string InsertCurrency(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        global::DLLCurrencySymbol.PL_CurrencyMaster pobj = new global::DLLCurrencySymbol.PL_CurrencyMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.CurrencyName = jdv["CurrencyName"];
                pobj.CurrencySymbol = jdv["CurrencySymbol"];
                pobj.Status = Convert.ToInt32(jdv["Status"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                global::DLLCurrencySymbol.BAL_CurrencyMaster.InsertCurrency(pobj);
                if (pobj.isException != true)
                {
                    //return pobj.Ds.GetXml();
                    return "true";
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
    public static string BindCurrencyList(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        global::DLLCurrencySymbol.PL_CurrencyMaster pobj = new global::DLLCurrencySymbol.PL_CurrencyMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.CurrencyName = jdv["CurrencyName"];
                pobj.CurrencySymbol = jdv["CurrencySymbol"];
                pobj.Status = Convert.ToInt32(jdv["Status"]);
                pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                global::DLLCurrencySymbol.BAL_CurrencyMaster.BindCurrencyList(pobj);
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
    [WebMethod]
    public static string DeleteCurrency(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        global::DLLCurrencySymbol.PL_CurrencyMaster pobj = new global::DLLCurrencySymbol.PL_CurrencyMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.CurrencyAutoId = Convert.ToInt32(jdv["CurrencyAutoId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                global::DLLCurrencySymbol.BAL_CurrencyMaster.DeleteCurrency(pobj);
                if (pobj.isException != true)
                {
                    //return pobj.Ds.GetXml();
                    return "true";
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
    public static string editCurrency(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        global::DLLCurrencySymbol.PL_CurrencyMaster pobj = new global::DLLCurrencySymbol.PL_CurrencyMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.CurrencyAutoId = Convert.ToInt32(jdv["CurrencyAutoId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                global::DLLCurrencySymbol.BAL_CurrencyMaster.editCurrency(pobj);
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
            return pobj.exceptionMessage = ex.Message;
        }
    }

    [WebMethod]
    public static string UpdateCurrency(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        global::DLLCurrencySymbol.PL_CurrencyMaster pobj = new global::DLLCurrencySymbol.PL_CurrencyMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.CurrencyAutoId = Convert.ToInt32(jdv["CurrencyAutoId"]);
                pobj.CurrencyName = jdv["CurrencyName"];
                pobj.CurrencySymbol = jdv["CurrencySymbol"];
                pobj.Status = Convert.ToInt32(jdv["Status"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                global::DLLCurrencySymbol.BAL_CurrencyMaster.UpdateCurrency(pobj);
                if (pobj.isException != true)
                {
                    //return pobj.Ds.GetXml();
                    return "true";
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