using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.Script.Serialization;
using System.Web.Services;
using DLLProductMaster;
using System.Data;
using Newtonsoft.Json;

public partial class Pages_ProductList : System.Web.UI.Page
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
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/ProductList.js"));
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
    public static string BindProductList(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_ProductMaster pobj = new PL_ProductMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.ProductName = jdv["Product"];
                pobj.DeptId = Convert.ToInt32(jdv["DeptId"]);
                pobj.BrandAutoId = Convert.ToInt32(jdv["Brand"]);
                pobj.CatgoryAutoId = Convert.ToInt32(jdv["Category"]);
                pobj.Status = Convert.ToInt32(jdv["Status"]);
                pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_ProductMaster.BindProductList(pobj);
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
    public static string ChangeInBulk(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_ProductMaster pobj = new PL_ProductMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.VerificationCode = Convert.ToInt32(jdv["VerificationCode"]);
                pobj.DeptId = Convert.ToInt32(jdv["DeptId"]);
                pobj.BrandAutoId = Convert.ToInt32(jdv["brandId"]);
                pobj.CatgoryAutoId = Convert.ToInt32(jdv["CategoryId"]);
                pobj.AgeRestrictionId = Convert.ToInt32(jdv["AgeRestId"]);
                pobj.TaxAutoId = Convert.ToInt32(jdv["TaxId"]);
                pobj.MeasurementUnitId = Convert.ToInt32(jdv["MeasureUnitId"]);
                pobj.ProductSize =jdv["ProductSize"];
                if(jdv["CostPrice"] !="" && jdv["CostPrice"] !=null)
                {
                    pobj.CostPrice = Convert.ToDecimal(jdv["CostPrice"]);
                }
                if(jdv["SellingPrice"]!="" && jdv["SellingPrice"]!=null)
                {
                    pobj.UnitPrice = Convert.ToDecimal(jdv["SellingPrice"]);
                }
                if (jdv["SecUnitPrice"] != "" && jdv["SecUnitPrice"] != null)
                {
                    pobj.SecondaryUnitPrice = Convert.ToDecimal(jdv["SecUnitPrice"]);
                }
                pobj.Status = Convert.ToInt32(jdv["Status"]);
                pobj.ProductIdsList = jdv["ProductIdString"];
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_ProductMaster.ChangeInBulk(pobj);
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