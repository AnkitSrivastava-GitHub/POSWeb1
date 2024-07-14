using System;
using DLLRoyaltyMaster;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_RoyaltyMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
        {
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/RoyaltyMaster.js"));
            Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
        }
        else
        {
            Session.Abandon();
            Response.Redirect("~/Default.aspx", false);
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
    public static string UpdateRoyalty(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_RoyaltyMaster pobj = new PL_RoyaltyMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.AmtPerRoyaltyPoint = Convert.ToDecimal(jdv["AmtPerRoyaltyPoint"]);
                pobj.MinOrderAmt = Convert.ToDecimal(jdv["MinOrderAmt"]);
                pobj.RoyaltyStatus = Convert.ToInt32(jdv["Royaltytatus"]);
                pobj.RoyaltyAutoId = Convert.ToInt32(jdv["RoyaltyId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_RoyaltyMaster.UpdateRoyalty(pobj);
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
    public static string UpdateAmtRoyalty(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_RoyaltyMaster pobj = new PL_RoyaltyMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Amount = Convert.ToDecimal(jdv["RoyaltyApointsAsPerAmt"]);
                pobj.MinOrderAmtForRoyalty = Convert.ToDecimal(jdv["MinOrderAmtForRoyalty"]);
                pobj.RoyaltyPoint = Convert.ToInt32(jdv["RoyaltyPoints"]);
                pobj.AmtStatus = Convert.ToInt32(jdv["AmtRoyaltyStatus"]);
                pobj.AmtRoyaltyAutoId = Convert.ToInt32(jdv["AmtRoyaltyId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_RoyaltyMaster.UpdateAmtRoyalty(pobj);
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
    public static string RoyaltyList()
    {
        //var jss = new JavaScriptSerializer();
        //var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_RoyaltyMaster pobj = new PL_RoyaltyMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                //pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                //pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                BAL_RoyaltyMaster.BindRoyaltyList(pobj);
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


}