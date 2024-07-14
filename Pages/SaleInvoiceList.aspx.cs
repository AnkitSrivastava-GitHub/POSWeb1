using DLLOrderMaster;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_SaleInvoiceList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["EmpAutoId"] != null)
        {
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/SaleInvoiceList.js"));
            Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
        }
        else
        {
            Session.Abandon();
            Response.Redirect("~/Default.aspx", false);
        }
        
    }
    [WebMethod(EnableSession = true)]
    public static string BindSaleInvoiceList2(string dataValues)
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValues);
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                if (jdv["InvoiceFromDate"] != "")
                {
                    pobj.FromDate = Convert.ToDateTime(jdv["InvoiceFromDate"]);
                }
                if (jdv["InvoiceToDate"] != "")
                {
                    pobj.ToDate = Convert.ToDateTime(jdv["InvoiceToDate"]);
                }
                pobj.InvoiceNo = jdv["InvoiceNo"];
                pobj.CustomerName = jdv["CustomerName"];
                pobj.CreatedFrom = jdv["CreatedFrom"];
                pobj.TerminalId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BL_orderMaster.SaleInvoiceList(pobj);
                if (pobj.isException != true)
                {
                    return pobj.Ds.GetXml();
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
    public static string BindSaleInvoiceList(string dataValues)
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValues);
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                if (jdv["InvoiceFromDate"] != "")
                {
                    pobj.FromDate = Convert.ToDateTime(jdv["InvoiceFromDate"]);
                }
                if (jdv["InvoiceToDate"] != "")
                {
                    pobj.ToDate = Convert.ToDateTime(jdv["InvoiceToDate"]);
                }
                pobj.InvoiceNo = jdv["InvoiceNo"];
                pobj.CustomerName= jdv["CustomerName"];
                pobj.CreatedFrom = jdv["CreatedFrom"];
                pobj.TerminalId = Convert.ToInt32(jdv["Terminal"]);
                pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BL_orderMaster.SaleInvoiceList(pobj);
                if (pobj.isException != true)
                {
                    return pobj.Ds.GetXml();
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
    public static string BindSaleInvoiceItemList(int InvoiceAutoId)
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.InvoiceAutoId = Convert.ToInt32(InvoiceAutoId);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BL_orderMaster.SaleInvoiceItemList(pobj);
                if (pobj.isException != true)
                {
                    return pobj.Ds.GetXml();
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