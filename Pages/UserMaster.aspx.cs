using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.Script.Serialization;
using System.Web.Services;
using UserMaster;

public partial class Pages_UserMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if(System.Web.HttpContext.Current.Session["EmpAutoId"]==null)
            {
                Session.Abandon();
                Response.Redirect("~/Default.aspx", false);
            }
            else if (HttpContext.Current.Session["EmpType"].ToString() != "Admin")
            {
                Session.Abandon();
                Response.Redirect("~/Default.aspx", false);
            }
        }
        string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/UserMaster.js"));
        Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
    }
    [WebMethod]
    public static string BindDropDowns()
    {
        PL_UserMaster pobj = new PL_UserMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                BAL_UserMaster.BindUserType(pobj);
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
    public static string BindModuleList()
    {
        PL_UserMaster pobj = new PL_UserMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                BAL_UserMaster.BindModule(pobj);
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
    public static string BindStoreList()
    {
        PL_UserMaster pobj = new PL_UserMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_UserMaster.BindStoreList(pobj);
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
    public static string BindSubModuleList(string dataValue)
    {
        PL_UserMaster pobj = new PL_UserMaster();
        try
        {
            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValue);
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.UserAutoId = Convert.ToInt32(jdv["UserAutoId"]);
                pobj.ModuleId = Convert.ToInt32(jdv["ModuleId"]);
                BAL_UserMaster.BindSubModule(pobj);
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
    public static string BindComponentList(string dataValue)
    {
        PL_UserMaster pobj = new PL_UserMaster();
        try
        {
            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValue);
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.UserAutoId = Convert.ToInt32(jdv["UserAutoId"]);
                pobj.ModuleId = Convert.ToInt32(jdv["ModuleId"]);
                BAL_UserMaster.BindComponentList(pobj);
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
    public static string InsertUser(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_UserMaster pobj = new PL_UserMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
               // pobj.UserId = jdv["Userid"];
                pobj.Password = jdv["Password"];
                //pobj.CompanyId = Convert.ToInt32(jdv["CompanyId"]);
                pobj.loginId = jdv["LoginId"];
                pobj.UserType = jdv["UserType"];
                pobj.FirstName = jdv["firstName"];
                pobj.LastName = jdv["LastName"];
                pobj.EmailId = jdv["Emailid"];
                pobj.PhoneNo = jdv["PhoneNo"];
                pobj.Status = jdv["Status"];
                pobj.AllowedApp = jdv["AllowedApp"];
                pobj.Security = jdv["security"];
                pobj.SecurityDisc = jdv["securityDisc"];
                pobj.HourlyRate = Convert.ToDecimal(jdv["HourlyRate"]);
                pobj.securityWithdraw = jdv["securityWithdraw"];
                pobj.StoreIdsList = jdv["StoreIdsList"];
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_UserMaster.InsertUser(pobj);
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
    public static string AssignModule(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_UserMaster pobj = new PL_UserMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {               
                pobj.UserAutoId = Convert.ToInt32(jdv["UserAutoId"]);
                pobj.ComponentIdsList = Convert.ToString(jdv["ComponentIdsList1"]);
                pobj.ComponentIds = Convert.ToString(jdv["ComponentIdsList"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_UserMaster.AssignModule(pobj);
                if (pobj.isException != true)
                {
                    //return pobj.Ds.GetXml(); ComponentIdsList1
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