using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.Services;
using System.Web.Script.Serialization;
using DLLPayout;


public partial class Pages_PayoutMaster : System.Web.UI.Page
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
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/Payout.js"));
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
    public static string bindTerminal()
    {
        PL_PayoutMaster pobj = new PL_PayoutMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.CompanyId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_PayoutMaster.BindTermianl(pobj);
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
    [WebMethod]
    public static string InsertPayout(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_PayoutMaster pobj = new PL_PayoutMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Expense = Convert.ToInt32(jdv["Expense"]);
                pobj.Vendor = Convert.ToInt32(jdv["Vendor"]);
                pobj.PayoutType = Convert.ToInt32(jdv["PayoutType"]);
                pobj.TerminalAutoId = Convert.ToInt32(jdv["Terminal"]);
                pobj.CompanyId=Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.PayTo = jdv["PayTo"];
                if (jdv["PayoutDate"] != "")
                {
                    pobj.PayoutDate = Convert.ToDateTime(jdv["PayoutDate"]);
                }
                if (jdv["PayoutTime"] != "")
                {
                    pobj.PayoutTime = jdv["PayoutTime"];
                }
                pobj.Remark = jdv["Remark"];
                pobj.Amount = Convert.ToDecimal(jdv["Amount"]);
                pobj.PaymentMode = jdv["PayoutMode"];
                pobj.TransactionId = jdv["TransactionId"];
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_PayoutMaster.InsertPayout(pobj);
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
    public static string BindPayoutList1(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_PayoutMaster pobj = new PL_PayoutMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Expense = Convert.ToInt32(jdv["Expense"]);
                pobj.Vendor = Convert.ToInt32(jdv["Vendor"]);
                pobj.PayoutType = Convert.ToInt32(jdv["PayoutType"]);
                pobj.PayTo = jdv["PayTo"];
                if (jdv["Amount"] != "")
                {
                    pobj.Amount = Convert.ToDecimal(jdv["Amount"]);
                }
                if (jdv["FromDate"] != "")
                {
                    pobj.FromDate = Convert.ToDateTime(jdv["FromDate"]);
                }
                if (jdv["ToDate"] != "")
                {
                    pobj.ToDate = Convert.ToDateTime(jdv["ToDate"]);
                }
                pobj.CompanyId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_PayoutMaster.BindPayoutList1(pobj);
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
    public static string BindPayoutList(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_PayoutMaster pobj = new PL_PayoutMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Expense = Convert.ToInt32(jdv["Expense"]);
                pobj.Vendor = Convert.ToInt32(jdv["Vendor"]);
                pobj.PayoutType = Convert.ToInt32(jdv["PayoutType"]);
                pobj.TerminalAutoId = Convert.ToInt32(jdv["TerminalId"]);
                pobj.PayTo = jdv["PayTo"];
                if (jdv["Amount"] != "")
                {
                    pobj.Amount = Convert.ToDecimal(jdv["Amount"]);
                }
                if (jdv["FromDate"] != "")
                {
                    pobj.FromDate = Convert.ToDateTime(jdv["FromDate"]);
                }
                if (jdv["ToDate"] != "")
                {
                    pobj.ToDate = Convert.ToDateTime(jdv["ToDate"]);
                }
                pobj.CompanyId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_PayoutMaster.BindPayoutList(pobj);
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
    public static string editPayout(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_PayoutMaster pobj = new PL_PayoutMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.PayoutAutoId = Convert.ToInt32(jdv["PayoutAutoId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_PayoutMaster.editPayout(pobj);
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
    public static string UpdatePayout2(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_PayoutMaster pobj = new PL_PayoutMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Expense = Convert.ToInt32(jdv["Expense"]);
                pobj.Vendor = Convert.ToInt32(jdv["Vendor"]);
                pobj.PayoutType = Convert.ToInt32(jdv["PayoutType"]);
                pobj.PayoutAutoId = Convert.ToInt32(jdv["PayoutAutoId"]);
                pobj.CompanyId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.PayTo = jdv["PayTo"];
                if (jdv["PayoutDate"] != "")
                {
                    pobj.PayoutDate = Convert.ToDateTime(jdv["PayoutDate"]);
                }
                if (jdv["PayoutTime"] != "")
                {
                    pobj.PayoutTime = jdv["PayoutTime"];
                }
                pobj.Remark = jdv["Remark"];
                pobj.Amount = Convert.ToDecimal(jdv["Amount"]);
                pobj.PaymentMode = jdv["PayoutMode"];
                //pobj.TransactionId = jdv["TransactionId"];
                pobj.TerminalAutoId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_PayoutMaster.UpdatePayout(pobj);
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
    public static string UpdatePayout(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_PayoutMaster pobj = new PL_PayoutMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Expense = Convert.ToInt32(jdv["Expense"]);
                pobj.Vendor = Convert.ToInt32(jdv["Vendor"]);
                pobj.PayoutType = Convert.ToInt32(jdv["PayoutType"]);
                pobj.TerminalAutoId = Convert.ToInt32(jdv["Terminal"]);
                pobj.PayoutAutoId = Convert.ToInt32(jdv["PayoutAutoId"]);
                pobj.CompanyId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.PayTo = jdv["PayTo"];
                if (jdv["PayoutDate"] != "")
                {
                    pobj.PayoutDate = Convert.ToDateTime(jdv["PayoutDate"]);
                }
                if (jdv["PayoutTime"] != "")
                {
                    pobj.PayoutTime = jdv["PayoutTime"];
                }
                pobj.Remark = jdv["Remark"];
                pobj.Amount = Convert.ToDecimal(jdv["Amount"]);
                pobj.PaymentMode =jdv["PayoutMode"];
                pobj.TransactionId = jdv["TransactionId"];
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_PayoutMaster.UpdatePayout(pobj);
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
    public static string DeletePayout(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_PayoutMaster pobj = new PL_PayoutMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.PayoutAutoId = Convert.ToInt32(jdv["PayoutAutoId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_PayoutMaster.DeletePayout(pobj);
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
    public static string InsertPayout1(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_PayoutMaster pobj = new PL_PayoutMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Expense = Convert.ToInt32(jdv["Expense"]);
                pobj.Vendor = Convert.ToInt32(jdv["Vendor"]);
                pobj.PayoutType = Convert.ToInt32(jdv["PayoutType"]);
                pobj.CompanyId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.PayTo = jdv["PayTo"];
                if (jdv["PayoutDate"] != "")
                {
                    pobj.PayoutDate = Convert.ToDateTime(jdv["PayoutDate"]);
                }
                if (jdv["PayoutTime"] != "")
                {
                    pobj.PayoutTime = jdv["PayoutTime"];
                }
                pobj.Remark = jdv["Remark"];
                pobj.Amount = Convert.ToDecimal(jdv["Amount"]);
                pobj.PaymentMode = jdv["PayoutMode"];
                // pobj.TransactionId = jdv["TransactionId"];
                pobj.ShiftId = Convert.ToInt32(HttpContext.Current.Session["ShiftId"]);
                pobj.TerminalAutoId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_PayoutMaster.InsertPayout(pobj);
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