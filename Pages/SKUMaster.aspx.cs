using DLLProductMaster;
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

public partial class Pages_SKUMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["EmpAutoId"] != null)
        {
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/SKUMaster.js"));
            Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<script id='checksdrivRequiredField'>" + text + "</script>"));
        }
        else
        {
            Session.Abandon();
            Response.Redirect("~/Default.aspx", false);
        }
    }
    [WebMethod]
    public static string BindProduct()
    {
        PL_SKUMaster pobj = new PL_SKUMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_SKUMaster.BindProduct(pobj);
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
    public static string BindUnitList(int ProductId,int SKUAutoId)
    {
        PL_SKUMaster pobj = new PL_SKUMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.ProductAutoId = Convert.ToInt32(ProductId);
                pobj.SKUAutoId = Convert.ToInt32(SKUAutoId);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_SKUMaster.BindUnitList(pobj);
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
    public static string InsertSKU(string dataValues, string SKUTableValues, string BarcodeTableValues)
    {
        if (HttpContext.Current.Session["EmpAutoId"] != null)
        {
            DataTable SKUdt = new DataTable();
            DataTable Barcodedt = new DataTable();
            SKUdt = JsonConvert.DeserializeObject<DataTable>(SKUTableValues);
            Barcodedt = JsonConvert.DeserializeObject<DataTable>(BarcodeTableValues);
            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValues);
            PL_SKUMaster pobj = new PL_SKUMaster();
            try
            {
                if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
                {
                    if (SKUdt.Rows.Count > 0)
                    {
                        pobj.SKUTable = SKUdt;
                    }
                    if (Barcodedt.Rows.Count > 0)
                    {
                        pobj.BarcodeTable = Barcodedt;
                    }
                    pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                    pobj.SKUName = jdv["SKUName"];
                    pobj.Image = jdv["SKUImage"];
                    pobj.Status = Convert.ToInt32(jdv["Status"]);
                    pobj.Description = jdv["Description"];
                    pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                    BAL_SKUMaster.InsertSKU(pobj);
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
    public static string editSKUDetail(int SKUAutoId)
    {
        PL_SKUMaster pobj = new PL_SKUMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.SKUAutoId = Convert.ToInt32(SKUAutoId);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_SKUMaster.editSKUDetail(pobj);
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
    public static string UpdateSKU(string dataValues, string SKUTableValues, string BarcodeTableValues)
    {
        if (HttpContext.Current.Session["EmpAutoId"] != null)
        {
            DataTable SKUdt = new DataTable();
            DataTable Barcodedt = new DataTable();
            SKUdt = JsonConvert.DeserializeObject<DataTable>(SKUTableValues);
            Barcodedt = JsonConvert.DeserializeObject<DataTable>(BarcodeTableValues);
            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValues);
            PL_SKUMaster pobj = new PL_SKUMaster();
            try
            {
                if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
                {
                    if (SKUdt.Rows.Count > 0)
                    {
                        pobj.SKUTable = SKUdt;
                    }
                    if (Barcodedt.Rows.Count > 0)
                    {
                        pobj.BarcodeTable = Barcodedt;
                    }
                    pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                    pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                    pobj.SKUName = jdv["SKUName"];
                    pobj.Image = jdv["SKUImage"];
                    pobj.Status = Convert.ToInt32(jdv["Status"]);
                    pobj.SKUAutoId = Convert.ToInt32(jdv["SKUAutoId"]);
                    pobj.VerificationCode = Convert.ToInt32(jdv["verificationCode"]);
                    pobj.Description = jdv["Description"];
                    pobj.SKUProductDeletedIds = jdv["SKUProductDeletedIds"];
                    pobj.SKUBarcodeDeletedIds = jdv["SKUBarcodeDeletedIds"];
                    BAL_SKUMaster.UpdateSKU(pobj);
                    if (!pobj.isException)
                    {
                        return pobj.Ds.GetXml(); 
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
    public static string ValidateBarcode(string Barcode, int SKUId)
    {
        PL_SKUMaster pobj = new PL_SKUMaster();
        try
        {
            //var jss = new JavaScriptSerializer();
            //var jdv = jss.Deserialize<dynamic>(dataValue);
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Barcode = Barcode;
                pobj.SKUAutoId = Convert.ToInt32(SKUId);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_SKUMaster.ValidateBarcode(pobj);
                if (pobj.isException != true)
                {
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

