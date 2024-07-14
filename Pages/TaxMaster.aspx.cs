using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using DLLTaxMaster;

public partial class Pages_TaxMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["EmpAutoId"] != null)
        {
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/TaxMaster.js"));
            Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
        }
        else
        {
            Session.Abandon();
            Response.Redirect("~/Default.aspx", false);
        }
    }
    [WebMethod]
    public static string InsertTax(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_TaxMaster pobj = new PL_TaxMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.TaxName = jdv["TaxName"];
                pobj.TaxPercentage = Convert.ToDecimal(jdv["TaxPercentage"]);
                pobj.Status = Convert.ToInt32(jdv["Status"]);
                //pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_TaxMaster.InsertTax(pobj);
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
    public static string BindTaxList(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_TaxMaster pobj = new PL_TaxMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.TaxName = jdv["TaxName"];
                pobj.Status = Convert.ToInt32(jdv["Status"]);
                pobj.TaxSPercentage = Convert.ToDecimal(jdv["TaxPercentage"]);
                pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_TaxMaster.BindTaxList(pobj);
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
    public static string DeleteTax(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_TaxMaster pobj = new PL_TaxMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.TaxAutoId = Convert.ToInt32(jdv["TaxAutoId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_TaxMaster.DeleteTax(pobj);
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
    public static string editTax(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_TaxMaster pobj = new PL_TaxMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.TaxAutoId = Convert.ToInt32(jdv["TaxAutoId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_TaxMaster.editTax(pobj);
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
    public static string UpdateTax(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_TaxMaster pobj = new PL_TaxMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.TaxAutoId = Convert.ToInt32(jdv["TaxAutoId"]);
                pobj.TaxName = jdv["TaxName"];
                pobj.TaxPercentage = Convert.ToDecimal(jdv["TaxPer"]);
                pobj.Status = Convert.ToInt32(jdv["Status"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_TaxMaster.UpdateTax(pobj);
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