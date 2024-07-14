using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.Services;
using System.Web.Script.Serialization;
using VendorMaster;

public partial class Pages_ShowVendorMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
        {

            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/VendorList.js"));
            Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
        }
        else
        {
            Session.Abandon();
            Response.Redirect("~/Default.aspx", false);
        }
    }
    [WebMethod]
    public static string BindVendorList(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_VendorMaster pobj = new PL_VendorMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                //pobj.CompanyId = Convert.ToInt32(jdv["CompanyId"]);
                pobj.VendorName = jdv["Name"];
                pobj.VendorCode = jdv["VendorCode"];
                pobj.EmailId = jdv["EmailId"];
                pobj.Status = jdv["Status"];
                pobj.MobileNo = jdv["PhoneNo"];
                pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_VendorMaster.BindVendorList(pobj);
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
    public static string editVendorDetail(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_VendorMaster pobj = new PL_VendorMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.VendorAutoId = Convert.ToInt32(jdv["AutoId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_VendorMaster.editVendorDetail(pobj);
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
    public static string UpdateVendor(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_VendorMaster pobj = new PL_VendorMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {

                pobj.VendorCode = jdv["VendorCode"];
                pobj.CompanyId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.VendorName = jdv["VendorName"];
                pobj.VendorAutoId = Convert.ToInt32(jdv["AutoId"]);
                pobj.MobileNo = jdv["MobileNo"];
                pobj.Address = jdv["Address"];
                pobj.State = Convert.ToInt32(jdv["State"]);
                pobj.City = jdv["City"];
                pobj.ZipCode = jdv["zipcode"];
                pobj.EmailId = jdv["EmailId"];
                pobj.Status = jdv["Status"];
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_VendorMaster.UpdateVendor(pobj);

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
    public static string DeleteVendor(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_VendorMaster pobj = new PL_VendorMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.VendorAutoId = Convert.ToInt32(jdv["AutoId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_VendorMaster.DeleteVendor(pobj);
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