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
using CouponMaster;

public partial class Pages_ProductMaster : System.Web.UI.Page
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
            string text = File.ReadAllText(Server.MapPath("/Pages/CustomJS/ProductMaster.js"));
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
    public static string BindDropDowns()
    {
        PL_ProductMaster pobj = new PL_ProductMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(System.Web.HttpContext.Current.Session["StoreId"]);
                BAL_ProductMaster.BindMaster(pobj);
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
            return "false";
        }
    }
    [WebMethod]
    public static string InsertProduct(string dataValue, string TableValues, string VendorProductList, string BarcodeTableValues)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_ProductMaster pobj = new PL_ProductMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                DataTable dt = new DataTable();
                dt = JsonConvert.DeserializeObject<DataTable>(TableValues);
                DataTable VendorProductdt = new DataTable();
                VendorProductdt = JsonConvert.DeserializeObject<DataTable>(VendorProductList);
                DataTable Barcodedt = new DataTable();
                Barcodedt = JsonConvert.DeserializeObject<DataTable>(BarcodeTableValues);
                if (dt.Rows.Count > 0)
                {
                    pobj.DT_PakingType = dt;
                }
                if (VendorProductdt.Rows.Count > 0)
                {
                    pobj.DT_VendorProductCode = VendorProductdt;
                }
                if (Barcodedt.Rows.Count > 0)
                {
                    pobj.DT_Barcode = Barcodedt;
                }
                pobj.BrandAutoId = Convert.ToInt32(jdv["Brand"]);
                pobj.DeptId = Convert.ToInt32(jdv["DeptId"]);
                pobj.VendorId = Convert.ToInt32(jdv["VendorId"]);
                pobj.CatgoryAutoId = Convert.ToInt32(jdv["Catgory"]);
                pobj.ProductName = jdv["Product"];
                pobj.ProductShortName = jdv["ProductShortName"];
                pobj.AgeRestrictionId = Convert.ToInt32(jdv["AgeRestriction"]);
                pobj.Status = Convert.ToInt32(jdv["Status"]);
                pobj.ProductSize = jdv["ProductSize"];
                pobj.GroupId = Convert.ToInt32(jdv["GroupId"]);
                pobj.ManageStock = Convert.ToInt32(jdv["MS"]);
                pobj.InStockQty = Convert.ToInt32(jdv["IS"]);
                pobj.AlertQty = Convert.ToInt32(jdv["AS"]);
                pobj.Description = jdv["Description"];
                pobj.ViewImage = Convert.ToInt32(jdv["viewImage"]);
                pobj.Image = jdv["Image"];
                pobj.MeasurementUnit = jdv["MeasurementUnit"];
                pobj.StoreIdsList = jdv["StoreIdsList"];
                pobj.TaxAutoId = Convert.ToInt32(jdv["TaxId"]);
                pobj.WebAvailability = jdv["WebAvailability"];
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_ProductMaster.InsertProduct(pobj);
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

    [WebMethod]
    public static string BindStoreList()
    {
        PL_ProductMaster pobj = new PL_ProductMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_ProductMaster.BindStoreList(pobj);
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
    public static string EditProductDetail(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_ProductMaster pobj = new PL_ProductMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.AutoId = Convert.ToInt32(jdv["AutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_ProductMaster.EditProductDetail(pobj);
                if (pobj.isException != true)
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
            pobj.isException = true;
            return pobj.exceptionMessage = ex.Message;
        }
    }

    [WebMethod]
    public static string UpdateProduct(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_ProductMaster pobj = new PL_ProductMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.AutoId = Convert.ToInt32(jdv["AutoId"]);
                pobj.DeptId = Convert.ToInt32(jdv["DeptId"]);
                pobj.BrandAutoId = Convert.ToInt32(jdv["Brand"]);
                pobj.CatgoryAutoId = Convert.ToInt32(jdv["Catgory"]);
                pobj.VendorId = Convert.ToInt32(jdv["VendorId"]);
                pobj.ProductName = jdv["Product"];
                pobj.ProductShortName = jdv["ProductShortName"];
                pobj.AgeRestrictionId = Convert.ToInt32(jdv["AgeRestriction"]);
                pobj.ProductSize = jdv["ProductSize"];
                pobj.GroupId = Convert.ToInt32(jdv["GroupId"]);
                pobj.ManageStock = Convert.ToInt32(jdv["MS"]);
                pobj.InStockQty = Convert.ToInt32(jdv["IS"]);
                pobj.AlertQty = Convert.ToInt32(jdv["AS"]);
                pobj.Status = Convert.ToInt32(jdv["Status"]);
                pobj.Description = jdv["Description"];
                pobj.MeasurementUnit = jdv["MeasurementUnit"];
                pobj.ViewImage = Convert.ToInt32(jdv["viewImage"]);
                pobj.TaxAutoId = Convert.ToInt32(jdv["TaxId"]);
                pobj.WebAvailability = jdv["WebAvailability"];
                pobj.Image = jdv["Image"];
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_ProductMaster.UpdateProduct(pobj);
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

    [WebMethod]
    public static string EditPacking(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_ProductMaster pobj = new PL_ProductMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.AutoId = Convert.ToInt32(jdv["AutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_ProductMaster.EditPacking(pobj);
                if (pobj.isException != true)
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
            pobj.isException = true;
            return pobj.exceptionMessage = ex.Message;
        }
    }

    [WebMethod]
    public static string UpdatePacking(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_ProductMaster pobj = new PL_ProductMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.AutoId = Convert.ToInt32(jdv["AutoId"]);
                pobj.ProductAutoId = Convert.ToInt32(jdv["ProductAutoId"]);
                pobj.Packing = jdv["Packing"];
                pobj.Barcode = jdv["Barcode"];
                pobj.NoOfPieces = Convert.ToInt32(jdv["NoOfPieces"]);
                pobj.PieceSize = jdv["PieceSize"];
                pobj.SecondaryUnitPrice = Convert.ToDecimal(jdv["SecondaryUnitPrice"]);
                pobj.ImageName = jdv["ImageName"];
                pobj.WebAvailability = jdv["WebAvailability"];
                pobj.CostPrice = Convert.ToDecimal(jdv["CP"]);
                pobj.UnitPrice = Convert.ToDecimal(jdv["SP"]);
                pobj.TaxAutoId = Convert.ToInt32(jdv["Tax"]);
                pobj.ManageStock = Convert.ToInt32(jdv["MS"]);
                pobj.InStock = Convert.ToInt32(jdv["InStock"]);
                pobj.LowStock = Convert.ToInt32(jdv["LowStock"]);
                pobj.Status = Convert.ToInt32(jdv["Status"]);
                pobj.VerificationCode= Convert.ToInt32(jdv["verificationCode"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_ProductMaster.UpdatePacking(pobj);
                if (pobj.isException != true)
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
            pobj.isException = true;
            return pobj.exceptionMessage = ex.Message;
        }
    }

    [WebMethod]
    public static string AddPacking(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_ProductMaster pobj = new PL_ProductMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.ProductAutoId = Convert.ToInt32(jdv["ProductAutoId"]);
                pobj.Packing = jdv["Packing"];
                pobj.NoOfPieces = Convert.ToInt32(jdv["NoOfPieces"]);
                pobj.PieceSize = jdv["PieceSize"];
                pobj.SecondaryUnitPrice = Convert.ToDecimal(jdv["SecondaryUnitPrice"]);
                pobj.ImageName = jdv["ImageName"];
                pobj.WebAvailability = jdv["WebAvailability"];
                pobj.Barcode = jdv["Barcode"];
                pobj.CostPrice = Convert.ToDecimal(jdv["CP"]);
                pobj.UnitPrice = Convert.ToDecimal(jdv["SP"]);
                pobj.TaxAutoId = Convert.ToInt32(jdv["Tax"]);
                pobj.ManageStock = Convert.ToInt32(jdv["MS"]);
                pobj.InStock = Convert.ToInt32(jdv["InStock"]);
                pobj.LowStock = Convert.ToInt32(jdv["LowStock"]);
                pobj.Status = Convert.ToInt32(jdv["Status"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_ProductMaster.AddPacking(pobj);
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
    [WebMethod]
    public static string ValidateBarcode(string dataValue)
    {
        PL_ProductMaster pobj = new PL_ProductMaster();
        try
        {
            var jss = new JavaScriptSerializer();
            var jdv=jss.Deserialize<dynamic>(dataValue);
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Barcode = jdv["Barcode"];
                pobj.ProductAutoId =Convert.ToInt32(jdv["ProductAutoId"]);
                BAL_ProductMaster.ValidateBarcode(pobj);
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

    [WebMethod]
    public static string ChangeProductStatus(int AutoId,int Status)
    {
        PL_ProductMaster pobj = new PL_ProductMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.AutoId = Convert.ToInt32(AutoId);
                pobj.Status = Convert.ToInt32(Status);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BAL_ProductMaster.ChangeProductStatus(pobj);
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
    [WebMethod]
    public static string DeleteVendorProductFromDB(int AutoId)
    {
        PL_ProductMaster pobj = new PL_ProductMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.AutoId = Convert.ToInt32(AutoId);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_ProductMaster.DeleteVendorProductFromDB(pobj);
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
    [WebMethod]
    
    public static string UpdateProductVendorInDB(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_ProductMaster pobj = new PL_ProductMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.AutoId = Convert.ToInt32(jdv["AutoId"]);
                pobj.VendorId = Convert.ToInt32(jdv["VendorId"]);
                pobj.VendorProductCode = jdv["VendorProductCode"];
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_ProductMaster.UpdateProductVendorInDB(pobj);
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
    }[WebMethod]
    
    public static string AddVendorInDB(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_ProductMaster pobj = new PL_ProductMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.AutoId = Convert.ToInt32(jdv["AutoId"]);
                pobj.VendorId = Convert.ToInt32(jdv["VendorId"]);
                pobj.VendorProductCode = jdv["VendorProductCode"];
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_ProductMaster.AddVendorInDB(pobj);
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

    [WebMethod]
    public static string BindAgeRestriction(int DeptId)
    {
        PL_ProductMaster pobj = new PL_ProductMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.DeptId = Convert.ToInt32(DeptId);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_ProductMaster.BindAgeRestriction(pobj);
                if (pobj.isException != true)
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
            pobj.isException = true;
            return pobj.exceptionMessage = ex.Message;
        }
    }
    [WebMethod]
    public static string AddBarcodeInDB(string dataValue)
    {
        PL_ProductMaster pobj = new PL_ProductMaster();
        try
        {
            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValue);
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.ProductAutoId = Convert.ToInt32(jdv["ProductAutoId"]);
                pobj.Barcode = jdv["Barcode"];
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_ProductMaster.AddBarcodeInDB(pobj);
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
    }[WebMethod]
    public static string UpdateBarcodeInDB(string dataValue)
    {
        PL_ProductMaster pobj = new PL_ProductMaster();
        try
        {
            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValue);
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.ProductAutoId = Convert.ToInt32(jdv["ProductAutoId"]);
                pobj.Barcode = jdv["Barcode"];
                pobj.BarcodeForEdit = jdv["BarcodeForEdit"];
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_ProductMaster.UpdateBarcodeInDB(pobj);
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
    [WebMethod]
    public static string DeleteBarcodeInDB(string dataValue)
    {
        PL_ProductMaster pobj = new PL_ProductMaster();
        try
        {
            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValue);
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.ProductAutoId = Convert.ToInt32(jdv["ProductAutoId"]);
                pobj.Barcode = jdv["Barcode"];
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_ProductMaster.DeleteBarcodeInDB(pobj);
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
    [WebMethod]
    public static string ValidateVendorProductCode(string dataValue)
    {
        PL_ProductMaster pobj = new PL_ProductMaster();
        try
        {
            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValue);
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.VendorId = Convert.ToInt32(jdv["VendorId"]);
                pobj.VendorProductCode = jdv["VendorProductCode"];
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BAL_ProductMaster.ValidateVendorProductCode(pobj);
                if (pobj.isException != true)
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
            pobj.isException = true;
            return pobj.exceptionMessage = ex.Message;
        }
    }
}