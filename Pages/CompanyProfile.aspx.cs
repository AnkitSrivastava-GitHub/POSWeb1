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

public partial class Pages_CompanyProfile : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["EmpAutoId"]==null)
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
        string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/CompanyProfile.js"));
        Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
    }
    [WebMethod]
    public static string bindCurrency()
    {
        PL_CompanyProfile pobj = new PL_CompanyProfile();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                BAL_CompanyProfile.bindCurrency(pobj);
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
            return ex.Message;
        }
    }
    [WebMethod]
    public static string InsertStore(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_CompanyProfile pobj = new PL_CompanyProfile();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                //pobj.AutoId = Convert.ToInt32(jdv["AutoId"]);
                pobj.CompanyName = jdv["companyName"];
                pobj.Billingaddress = jdv["BillingAddress"];
                pobj.ContactPerson = jdv["ContactPerson"];
                pobj.country = jdv["Country"];
                pobj.mobileNo = jdv["MobileNo"];
                pobj.Website = jdv["Website"];
                pobj.Faxno = jdv["FaxNo"];
                pobj.state = jdv["State"];
                pobj.City = jdv["City"];
                pobj.ZipCode = jdv["ZipCode"];
                pobj.EmailId = jdv["EmailId"];
                pobj.phoneno = jdv["PhoneNo"];
                pobj.Vatno = jdv["VatNo"];
                pobj.CLogo = jdv["CLogo"];
                pobj.status = Convert.ToInt32(jdv["Status"]);
                pobj.CurrencyId = Convert.ToInt32(jdv["CurrencyId"]);
                pobj.AllowLottoSale = Convert.ToInt32(jdv["AllowLottoSale"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_CompanyProfile.InsertStore(pobj);

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
    public static string updateCompanyProfile(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_CompanyProfile pobj = new PL_CompanyProfile();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.AutoId = Convert.ToInt32(jdv["AutoId"]);
                pobj.CompanyName = jdv["companyName"];
                pobj.Billingaddress = jdv["BillingAddress"];
                pobj.ContactPerson = jdv["ContactPerson"];
                pobj.country = jdv["Country"];
                pobj.mobileNo = jdv["MobileNo"];
                pobj.Website = jdv["Website"];
                pobj.Faxno = jdv["FaxNo"];
                pobj.state = jdv["State"];
                pobj.City = jdv["City"];
                pobj.ZipCode = jdv["ZipCode"];
                pobj.EmailId = jdv["EmailId"];
                pobj.phoneno = jdv["PhoneNo"];
                pobj.Vatno = jdv["VatNo"];
                pobj.CLogo = jdv["CLogo"];
                pobj.status = Convert.ToInt32(jdv["Status"]);
                pobj.CurrencyId = Convert.ToInt32(jdv["CurrencyId"]);
                pobj.AllowLottoSale = Convert.ToInt32(jdv["AllowLottoSale"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_CompanyProfile.updateCompanyProfile(pobj);

                if (pobj.isException != true)
                {
                    if (pobj.StoreId == pobj.AutoId)
                    {
                        if (pobj.Ds.Tables[0].Rows.Count > 0)
                        {
                            string StoreId = pobj.Ds.Tables[0].Rows[0]["StoreId"].ToString();
                            string CompanyName = pobj.Ds.Tables[0].Rows[0]["CompanyName"].ToString();
                            HttpContext.Current.Session.Add("StoreId", StoreId);
                            HttpContext.Current.Session.Add("CompanyName", CompanyName);
                        }
                    }
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