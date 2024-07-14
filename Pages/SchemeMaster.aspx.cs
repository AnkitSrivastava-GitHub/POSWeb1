using DLLSchemeMaster;
using DLLSKUMaster;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_SchemeMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
        {
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/SchemeMaster.js"));
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
    public static string BindSKU()
    {
        PL_SchemeMaster pobj = new PL_SchemeMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_SchemeMaster.BindActiveSKU(pobj);
                if (pobj.isException != true)
                {
                    string json = "";
                    foreach (DataRow dr in pobj.Ds.Tables[0].Rows)
                    {
                        json += dr[0].ToString();
                    }
                    if (json == "")
                    {
                        json = "[]";
                    }
                    return json;
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
    public static string BindSKUDetails(int SKUId)
    {
        PL_SchemeMaster pobj = new PL_SchemeMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.SKUAutoId = Convert.ToInt32(SKUId);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_SchemeMaster.GetSKUdetail(pobj);
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
    [WebMethod(EnableSession = true)]
    public static string InsertScheme(string dataValues, string SchemeSKUTableValues)
    {
        if (HttpContext.Current.Session["EmpAutoId"] != null)
        {
            DataTable SchemeProductdt = new DataTable();
            SchemeProductdt = JsonConvert.DeserializeObject<DataTable>(SchemeSKUTableValues);
            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValues);
            PL_SchemeMaster pobj = new PL_SchemeMaster();
            try
            {
                if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
                {
                    if (SchemeProductdt.Rows.Count > 0)
                    {
                        pobj.SchemeProductList = SchemeProductdt;
                    }
                    if (jdv["FromDate"] != "" && jdv["FromDate"] != null)
                    {
                        pobj.FromDate = Convert.ToDateTime(jdv["FromDate"]);
                    }
                    if (jdv["ToDate"] != "" && jdv["ToDate"] != null)
                    {
                        pobj.ToDate = Convert.ToDateTime(jdv["ToDate"]);
                    }
                    pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                    pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                    pobj.SchemeName = jdv["SchemeName"];
                    pobj.SchemeDaysString = jdv["SchemeDaysString"];
                    pobj.SKUAutoId = Convert.ToInt32(jdv["SKUId"]);
                    pobj.Status = Convert.ToInt32(jdv["Status"]);
                    pobj.Quantity = Convert.ToInt32(jdv["Quantity"]);
                    BAL_SchemeMaster.InsertScheme(pobj);
                    if (!pobj.isException)
                    {
                        return "true";
                    }
                    else
                    {
                        return pobj.exceptionMessage;
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
        else
        {
            return "Session";
        }
    }

    [WebMethod]
    public static string BindSchemeDetails(int SchemeAutoId)
    {
        PL_SchemeMaster pobj = new PL_SchemeMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.SchemeId = Convert.ToInt32(SchemeAutoId);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_SchemeMaster.BindSchemedetail(pobj);
                if (pobj.isException != true)
                {
                    //return pobj.Ds.GetXml();
                    string json = "";
                    foreach (DataRow dr in pobj.Ds.Tables[0].Rows)
                    {
                        json += dr[0].ToString();
                    }
                    if (json == "")
                    {
                        json = "[]";
                    }
                    return json;
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
    [WebMethod(EnableSession = true)]
    public static string UpdateScheme(string dataValues, string SchemeSKUTableValues)
    {
        if (HttpContext.Current.Session["EmpAutoId"] != null)
        {
            DataTable SchemeProductdt = new DataTable();
            SchemeProductdt = JsonConvert.DeserializeObject<DataTable>(SchemeSKUTableValues);
            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValues);
            PL_SchemeMaster pobj = new PL_SchemeMaster();
            try
            {
                if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
                {
                    if (SchemeProductdt.Rows.Count > 0)
                    {
                        pobj.SchemeProductList = SchemeProductdt;
                    }
                    if (jdv["FromDate"] != "" && jdv["FromDate"] != null)
                    {
                        pobj.FromDate = Convert.ToDateTime(jdv["FromDate"]);
                    }
                    if (jdv["ToDate"] != "" && jdv["ToDate"] != null)
                    {
                        pobj.ToDate = Convert.ToDateTime(jdv["ToDate"]);
                    }
                    pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                    pobj.SchemeDaysString = jdv["SchemeDaysString"];
                    pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                    pobj.SchemeName = jdv["SchemeName"];
                    pobj.SchemeId = Convert.ToInt32(jdv["SchemeId"]);
                    pobj.SKUAutoId = Convert.ToInt32(jdv["SKUAutoId"]);
                    pobj.Status = Convert.ToInt32(jdv["Status"]);
                    pobj.Quantity = Convert.ToInt32(jdv["Quantity"]);
                    BAL_SchemeMaster.UpdateScheme(pobj);
                    if (!pobj.isException)
                    {
                        return "true";
                    }
                    else
                    {
                        return pobj.exceptionMessage;
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
        else
        {
            return "Session";
        }
    }

}