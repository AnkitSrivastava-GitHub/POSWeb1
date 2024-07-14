using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.Services;
using System.Web.Script.Serialization;
using DLLCompanyProfile;

public partial class Pages_StoreList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (HttpContext.Current.Session["EmpAutoId"]== null)
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
        string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/StoreList.js"));
        Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
    }
    [WebMethod]
    public static string BindStoreList(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_CompanyProfile pobj = new PL_CompanyProfile();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.CompanyName = jdv["companyName"];
                pobj.ContactPerson = jdv["ContactPerson"];
                pobj.phoneno = jdv["MobileNo"];
                pobj.Website = jdv["Website"];
                pobj.status = Convert.ToInt32(jdv["Status"]);
                pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_CompanyProfile.BindStoreList(pobj);
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
    public static string editCompanyProfile(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_CompanyProfile pobj = new PL_CompanyProfile();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.AutoId = Convert.ToInt32(jdv["StoreAutoId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_CompanyProfile.editCompanyProfile(pobj);
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
    public static string updateCompanyProfile(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_CompanyProfile pobj = new PL_CompanyProfile();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.AutoId = Convert.ToInt32(jdv["AutoId"]);
                pobj.CompanyName = jdv["companyName"];
                pobj.Billingaddress = jdv["BillingAddress"];
                pobj.ContactPerson = jdv["ContactPerson"];
                pobj.country = jdv["Country"];
                pobj.mobileNo = jdv["MobileNo"];
                pobj.Website = jdv["Website"];
                pobj.state = jdv["State"];
                pobj.City = jdv["City"];
                pobj.ZipCode = jdv["ZipCode"];
                pobj.EmailId = jdv["EmailId"];
                pobj.phoneno = jdv["PhoneNo"];
                pobj.Faxno = jdv["FaxNo"];
                pobj.Vatno = jdv["VatNo"];
                pobj.CLogo = jdv["CLogo"];
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_CompanyProfile.updateCompanyProfile(pobj);

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
    public static string DeleteStore(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_CompanyProfile pobj = new PL_CompanyProfile();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.AutoId = Convert.ToInt32(jdv["AutoId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_CompanyProfile.DeleteStore(pobj);
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