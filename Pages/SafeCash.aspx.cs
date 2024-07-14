using System;
using System.IO;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;

public partial class Pages_SafeCash : System.Web.UI.Page
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
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/SafeCash.js"));
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
    public static string InsertSafeCash(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        global::SafeCash.PL_SafeCash pobj = new global::SafeCash.PL_SafeCash();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Mode = Convert.ToInt32(jdv["Mode"]);
                pobj.Status = Convert.ToInt32(jdv["Status"]);
                pobj.Amount = Convert.ToDecimal(jdv["Amount"]);
                pobj.Remark = jdv["Remark"];
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                if (Convert.ToInt32(jdv["Terminal"]) == 0 || jdv["Terminal"] == "" || jdv["Terminal"] == null)
                {
                    pobj.Terminal = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                }
                else
                {
                    pobj.Terminal = Convert.ToInt32(jdv["Terminal"]);
                }
                global::SafeCash.BAL_SafeCash.InsertSafeCash(pobj);
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
    public static string BindSafeCashList(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        global::SafeCash.PL_SafeCash pobj = new global::SafeCash.PL_SafeCash();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                if (Convert.ToInt32(jdv["Terminal"]) == 0 || jdv["Terminal"] == "")
                {
                    pobj.Terminal = Convert.ToInt32(0);
                }
                else
                {
                    pobj.Terminal = Convert.ToInt32(jdv["Terminal"]);
                }
                pobj.TerminalId = Convert.ToInt32(jdv["Terminal"]);
                pobj.Amount = Convert.ToDecimal(jdv["Amount"]);
                if (jdv["FromDate"] != "")
                {
                    pobj.FromDate = Convert.ToDateTime(jdv["FromDate"]);
                }
                if (jdv["ToDate"] != "")
                {
                    pobj.ToDate = Convert.ToDateTime(jdv["ToDate"]);
                }
                pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                pobj.Mode = Convert.ToInt32(jdv["Mode"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                global::SafeCash.BAL_SafeCash.BindSafeCashList(pobj);
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
    public static string DeleteSafeCash(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        global::SafeCash.PL_SafeCash pobj = new global::SafeCash.PL_SafeCash();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.SafeCashAutoId = Convert.ToInt32(jdv["SafeCashAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                global::SafeCash.BAL_SafeCash.DeleteSafeCash(pobj);
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
    public static string editSafeCash(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        global::SafeCash.PL_SafeCash pobj = new global::SafeCash.PL_SafeCash();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.SafeCashAutoId = Convert.ToInt32(jdv["SafeCashAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                global::SafeCash.BAL_SafeCash.editSafeCash(pobj);
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
    public static string UpdateSafeCash(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        global::SafeCash.PL_SafeCash pobj = new global::SafeCash.PL_SafeCash();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {

                pobj.Mode = Convert.ToInt32(jdv["Mode"]);
                pobj.Status = Convert.ToInt32(jdv["Status"]);
                pobj.Amount = Convert.ToDecimal(jdv["Amount"]);
                pobj.Remark = jdv["Remark"];
                pobj.SafeCashAutoId = Convert.ToInt32(jdv["SafeCashAutoId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                if (Convert.ToInt32(jdv["Terminal"]) == 0 || jdv["Terminal"] == null)
                {
                    pobj.Terminal = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                }
                else
                {
                    pobj.Terminal = Convert.ToInt32(jdv["Terminal"]);
                }
                global::SafeCash.BAL_SafeCash.UpdateSafeCash(pobj);
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