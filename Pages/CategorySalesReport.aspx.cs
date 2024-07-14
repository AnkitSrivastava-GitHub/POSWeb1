using System;
using DLLCategorySalesReport;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using DLLBrandMaster;
using System.Web.Script.Serialization;

public partial class Pages_CategorySalesReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["EmpAutoId"] != null)
        {
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/CategorySalesReport.js"));
            Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
        }
        else
        {
            Session.Abandon();
            Response.Redirect("~/Default.aspx", false);
        }
    }

    [WebMethod]
    public static string BindTerminalList()
    {
        var jss = new JavaScriptSerializer();
        //var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_CategorySalesReport pobj = new PL_CategorySalesReport();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
               
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_CategorySalesReport.BindTerminalList(pobj);
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
    public static string BindCategorySalesReport(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_CategorySalesReport pobj = new PL_CategorySalesReport();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                if(jdv["ReportDate"]!=null && jdv["ReportDate"] != "")
                {
                    pobj.ReportDate = Convert.ToDateTime(jdv["ReportDate"]);
                }
                pobj.TerminalId = Convert.ToInt32(jdv["TerminalId"]);
                pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                pobj.ShiftId = Convert.ToInt32(jdv["ShiftId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_CategorySalesReport.BindCategorySalesReport(pobj);
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
    public static string BindTicketSalesReport(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_CategorySalesReport pobj = new PL_CategorySalesReport();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                if (jdv["ReportDate"] != null && jdv["ReportDate"] != "")
                {
                    pobj.ReportDate = Convert.ToDateTime(jdv["ReportDate"]);
                }
                pobj.ShiftId = Convert.ToInt32(jdv["ShiftId"]);
                pobj.TerminalId = Convert.ToInt32(jdv["TerminalId"]);
                pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_CategorySalesReport.BindTicketSalesReport(pobj);
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
    public static string BindPayoutReport(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_CategorySalesReport pobj = new PL_CategorySalesReport();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                if (jdv["ReportDate"] != null && jdv["ReportDate"] != "")
                {
                    pobj.ReportDate = Convert.ToDateTime(jdv["ReportDate"]);
                }
                pobj.ShiftId = Convert.ToInt32(jdv["ShiftId"]);
                pobj.TerminalId = Convert.ToInt32(jdv["TerminalId"]);
                //pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                //pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_CategorySalesReport.BindPayoutReport(pobj);
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
    public static string BindTransDetailsReport(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_CategorySalesReport pobj = new PL_CategorySalesReport();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                if (jdv["ReportDate"] != null && jdv["ReportDate"] != "")
                {
                    pobj.ReportDate = Convert.ToDateTime(jdv["ReportDate"]);
                }
                pobj.ShiftId = Convert.ToInt32(jdv["ShiftId"]);
                pobj.TerminalId = Convert.ToInt32(jdv["TerminalId"]);
                //pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                //pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_CategorySalesReport.BindTransDetailsReport(pobj);
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
    public static string getShiftList(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_CategorySalesReport pobj = new PL_CategorySalesReport();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                if (jdv["ReportDate"] != null && jdv["ReportDate"] != "")
                {
                    pobj.ReportDate = Convert.ToDateTime(jdv["ReportDate"]);
                }
                pobj.TerminalId = Convert.ToInt32(jdv["TerminalId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_CategorySalesReport.getShiftList(pobj);
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
}