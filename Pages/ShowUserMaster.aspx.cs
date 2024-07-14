using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.Services;
using System.Web.Script.Serialization;
using UserMaster;


public partial class Pages_ShowUserMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if(System.Web.HttpContext.Current.Session["EmpAutoId"] == null)
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
        string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/UserList.js"));
        Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
    }
    [WebMethod]
    public static string BindUserList(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_UserMaster pobj = new PL_UserMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.CompanyId = Convert.ToInt32(jdv["CompanyId"]);
                pobj.FirstName = jdv["FirstName"];
                pobj.UserType = jdv["UserType"];
                pobj.loginId = jdv["LoginId"];
                pobj.EmailId = jdv["EmailId"];
                pobj.Status = jdv["Status"];
                pobj.PhoneNo = jdv["PhoneNo"];
                pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                 pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_UserMaster.BindUserList(pobj);
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
    public static string DeleteUser(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_UserMaster pobj = new PL_UserMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.UserAutoId = Convert.ToInt32(jdv["UserAutoId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_UserMaster.DeleteUser(pobj);
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
    public static string editUserDetail(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_UserMaster pobj = new PL_UserMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.UserAutoId = Convert.ToInt32(jdv["UserAutoId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_UserMaster.editUserDetail(pobj);
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
    public static string ShowAssignedModule(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_UserMaster pobj = new PL_UserMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.UserAutoId = Convert.ToInt32(jdv["UserAutoId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_UserMaster.ShowAssignedModule(pobj);
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
    public static string UpdateUser(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_UserMaster pobj = new PL_UserMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.UserAutoId = Convert.ToInt32(jdv["UserAutoId"]);
                pobj.loginId = jdv["LoginId"];
                //pobj.CompanyId = Convert.ToInt32(jdv["CompanyId"]);
                pobj.FirstName = jdv["FirstName"];
                pobj.LastName = jdv["LastName"];
                pobj.EmailId = jdv["EmailId"];
                pobj.PhoneNo = jdv["PhoneNo"];
                pobj.Password= jdv["Password"];
                pobj.UserType = jdv["UserType"];
                pobj.Status = jdv["Status"];
                pobj.AllowedApp = jdv["AllowedApp"];
                pobj.Security = jdv["security"];
                pobj.SecurityDisc = jdv["securityDisc"];
                pobj.HourlyRate = Convert.ToDecimal(jdv["HourlyRate"]);
                pobj.securityWithdraw = jdv["securityWithdraw"];
                pobj.StoreIdsList = jdv["StoreIdsList"];
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_UserMaster.UpdateUser(pobj);
               
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