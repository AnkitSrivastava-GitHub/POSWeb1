using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.Services;
using System.Web.Script.Serialization;
using CouponMaster;

public partial class Pages_ShowCouponMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
        {
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/GiftCardList.js"));
            Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
        }
        else
        {
            Session.Abandon();
            Response.Redirect("~/Default.aspx", false);
        }
    }
    [WebMethod]
    public static string BindCouponList(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_CouponMaster pobj = new PL_CouponMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.CouponCode = jdv["Couponcode"];
                pobj.Status = Convert.ToInt32(jdv["Status"]);
                pobj.UseStatus = Convert.ToInt32(jdv["UseStatus"]);
                if (jdv["StartDate"] != "" && jdv["StartDate"] != null)
                {
                    pobj.StartDate = Convert.ToDateTime(jdv["StartDate"]);
                }
                if (jdv["EndDate"] != "" && jdv["EndDate"] != null)
                {
                    pobj.EndDate = Convert.ToDateTime(jdv["EndDate"]);
                }
                pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_CouponMaster.BindCouponList(pobj);
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
    public static string DeleteCoupon(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_CouponMaster pobj = new PL_CouponMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.CouponAutoId = Convert.ToInt32(jdv["CouponAutoId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_CouponMaster.DeleteCoupon(pobj);
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
    public static string editCoupon(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_CouponMaster pobj = new PL_CouponMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.CouponAutoId = Convert.ToInt32(jdv["AutoId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_CouponMaster.editCoupon(pobj);
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
            return pobj.exceptionMessage = ex.Message;
        }
    }
    [WebMethod]
    public static string UpdateCoupon(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_CouponMaster pobj = new PL_CouponMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.CouponAutoId = Convert.ToInt32(jdv["CouponAutoId"]);
                pobj.CouponCode = jdv["Couponcode"];
                pobj.CouponDescription = jdv["CouponDescription"];
                pobj.CouponAmount = Convert.ToDecimal(jdv["Amount"]);
                pobj.CouponTerms = jdv["TermsDescription"];
                pobj.CouponType = Convert.ToInt32(jdv["CouponType"]);
                pobj.Discount = Convert.ToDecimal(jdv["Discount"]);
                pobj.StartDate = Convert.ToDateTime(jdv["StartDate"]);
                pobj.EndDate = Convert.ToDateTime(jdv["EndDate"]);
                pobj.Status = Convert.ToInt32(jdv["Status"]);
                //pobj.StoreIdString = jdv["StoreIdString"];
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_CouponMaster.UpdateCoupon(pobj);

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