using DllLogin;
using DLLOrderMaster;
using Newtonsoft.Json;
using System;
using System.Activities.Expressions;
using System.Collections.Generic;
using System.Data;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.NetworkInformation;
using System.Net.Sockets;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_PreInit(object sender, EventArgs e)
    {

        Session.Abandon();
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Session.Clear();
        }
        string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/Default.js"));
        Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
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
    public static string loginUser(string UserName, string Password)
    {
        PL_Login pobj = new PL_Login();
        try
        {
            pobj.UserName = UserName.Trim();
            pobj.Password = Password.Trim();
            //pobj.IPAddress = HttpContext.Current.Request.UserHostAddress;
            pobj.IPAddress = GetIp();
            HttpContext.Current.Session["UserName"] = null;
            if (string.IsNullOrEmpty(UserName) || string.IsNullOrEmpty(Password))
            {
                return "Username And / Or Password Incorrect";
            }
            BL_Login.login(pobj);
            if (!pobj.isException)
            {
                if (pobj.Ds.Tables[0].Rows.Count > 0)
                {
                    string CashierLogin = "NO";
                    string AutoId = pobj.Ds.Tables[0].Rows[0]["AutoId"].ToString();
                    string emptype = pobj.Ds.Tables[0].Rows[0]["EmpType"].ToString();
                    string username = pobj.Ds.Tables[0].Rows[0]["UserName"].ToString();
                    string firstname = pobj.Ds.Tables[0].Rows[0]["Name"].ToString();
                    string empTypeno = pobj.Ds.Tables[0].Rows[0]["EmpTypeNo"].ToString();
                    string ProfileName = pobj.Ds.Tables[0].Rows[0]["ProfileName"].ToString();
                    string Email = pobj.Ds.Tables[0].Rows[0]["Email"].ToString();
                    string BalanceStatus = pobj.Ds.Tables[0].Rows[0]["BalanceStatus"].ToString();
                    string ShiftId = pobj.Ds.Tables[0].Rows[0]["ShiftId"].ToString();                   
                    string EmpStoreCount = pobj.Ds.Tables[0].Rows[0]["EmpStoreCnt"].ToString();
                    HttpContext.Current.Session.Add("UserName", username);
                    HttpContext.Current.Session.Add("EmpFirstName", firstname);
                    HttpContext.Current.Session.Add("EmpAutoId", AutoId);
                    HttpContext.Current.Session.Add("EmpType", emptype);
                    HttpContext.Current.Session.Add("EmpTypeNo", empTypeno);
                    HttpContext.Current.Session.Add("ProfileName", ProfileName);
                    HttpContext.Current.Session.Add("UserEmail", Email);
                    HttpContext.Current.Session.Add("BalanceStatus", BalanceStatus);
                    HttpContext.Current.Session.Add("ShiftId", ShiftId);
                    HttpContext.Current.Session.Add("EmpStoreCount", EmpStoreCount);
                    HttpContext.Current.Session.Add("PageLoadCnt", 0);
                    HttpContext.Current.Session.Add("CashierLogin", CashierLogin);

                    if (pobj.Ds.Tables[0].Rows[0]["EmpType"].ToString() == "Cashier")
                    {
                        string CurrencySymbol = pobj.Ds.Tables[0].Rows[0]["CurrencySymbol"].ToString();
                        HttpContext.Current.Session.Add("CurrencySymbol", CurrencySymbol);
                        string CompanyName = pobj.Ds.Tables[0].Rows[0]["CompanyName"].ToString();
                        HttpContext.Current.Session.Add("CompanyName", CompanyName);
                        string StoreId = pobj.Ds.Tables[0].Rows[0]["StoreId"].ToString();
                        HttpContext.Current.Session.Add("StoreId", StoreId);
                    }
                    string LogInAutoId = pobj.Ds.Tables[1].Rows[0]["LogInAutoId"].ToString();
                    HttpContext.Current.Session.Add("LogInAutoId", LogInAutoId);
                    return pobj.Ds.GetXml();
                }
                else
                {
                    return pobj.exceptionMessage.ToString();
                }
            }
            else
            {
                return pobj.exceptionMessage.ToString();
            }
        }
        catch (Exception ex)
        {
            return "Authorised Access Only";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string BalanceStatus()
    {
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                if (HttpContext.Current.Session["EmpType"].ToString() == "Cashier")
                {
                    string BalanceStatus = "", Shift = "";
                    
                    BalanceStatus = HttpContext.Current.Session["BalanceStatus"].ToString();
                    Shift = HttpContext.Current.Session["ShiftId"].ToString();
                    DataTable table = new DataTable("BalanceStatus");
                    table.Columns.Add("ShiftId");
                    table.Columns.Add("Status");
                    table.Rows.Add(Shift, BalanceStatus);
                    DataSet set = new DataSet();
                    set.Tables.Add(table);
                    return set.GetXml();
                    
                }
                else
                {
                    return "Admin";
                }
            }
            else
            {
                return "Session";
            }
        }
        catch (Exception ex)
        {
            return ex.Message.ToString();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string OpeningBalance(string dataValues, string Currencydatatable)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValues);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                DataTable CurrencyTable = new DataTable();
                CurrencyTable = JsonConvert.DeserializeObject<DataTable>(Currencydatatable);
                if (CurrencyTable.Rows.Count > 0)
                {
                    pobj.CurrencyTable = CurrencyTable;
                }
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.TerminalId = Convert.ToInt32(jdv["Terminal"]);
                pobj.BalanceStatus = HttpContext.Current.Session["BalanceStatus"].ToString();
                pobj.OpeningBalance = Convert.ToDecimal(jdv["ClosingBalance"]);
                BL_orderMaster.OpeningBalance(pobj);
                if (!pobj.isException)
                {
                    HttpContext.Current.Session.Add("BalanceStatus", "Break");                   
                    if (pobj.Ds.Tables[0].Rows.Count > 0)
                    {
                        string ShiftId = pobj.Ds.Tables[0].Rows[0]["ShiftId"].ToString();
                        HttpContext.Current.Session.Add("ShiftId", ShiftId);
                        HttpContext.Current.Session.Add("BreakPopUp", 1);
                    }
                    return pobj.Ds.GetXml();
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
            pobj.exceptionMessage = ex.Message;
            return pobj.exceptionMessage;
        }
    }

    [WebMethod(EnableSession = true)]
    public static string BindClosCurrencyList(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.TerminalId = Convert.ToInt32(jdv["Terminal"]);
                BL_orderMaster.BindClosCurrencyList(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }
    public static string GetIp()
    {
        string ip = System.Web.HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
        if (string.IsNullOrEmpty(ip))
        {
            ip = System.Web.HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
        }
        return ip;
    }

    [WebMethod(EnableSession = true)]
    public static string BindTerminal()
    {
        PL_Login pobj = new PL_Login();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Userid = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BL_Login.BindTerminal(pobj);
                if (!pobj.isException)
                {
                    return pobj.Ds.GetXml();
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
            pobj.exceptionMessage = ex.Message;
            return pobj.exceptionMessage;
        }
    }

    [WebMethod(EnableSession = true)]
    public static string BindCurrencyList()
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.TerminalId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                BL_orderMaster.BindCurrencyList(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    public static string AssignTerminal(int TerminalId)
    {
        PL_Login pobj = new PL_Login();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Userid = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.LogInAutoId = Convert.ToInt32(HttpContext.Current.Session["LogInAutoId"]);
                pobj.TerminalId = Convert.ToInt32(TerminalId);
                BL_Login.AssignTerminal(pobj);
                if (!pobj.isException)
                {
                    string TerminalAutoId = "0", TerminalName="";
                    if (pobj.Ds.Tables[0].Rows.Count > 0)
                    {
                        TerminalName = pobj.Ds.Tables[0].Rows[0]["TerminalName"].ToString();
                        TerminalAutoId = pobj.Ds.Tables[0].Rows[0]["TerminalAutoId"].ToString();
                        HttpContext.Current.Session.Add("TerminalAutoId", TerminalAutoId);
                        HttpContext.Current.Session.Add("TerminalName", TerminalName);
                        return "true";
                    }
                    else
                    {
                        //TerminalAutoId = "0";
                        //HttpContext.Current.Session.Add("TerminalAutoId", TerminalAutoId);
                        return pobj.exceptionMessage.ToString();
                    }
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
            pobj.exceptionMessage = ex.Message;
            return pobj.exceptionMessage;
        }
    }

    [WebMethod(EnableSession = true)]
    public static string GetLocalIPAddress()
    {
        var host = Dns.GetHostEntry(Dns.GetHostName());
        foreach (var ip in host.AddressList)
        {
            if (ip.AddressFamily == AddressFamily.InterNetwork)
            {
                return ip.ToString();
            }
        }
        throw new Exception("No network adapters with an IPv4 address in the system.");
    }
}