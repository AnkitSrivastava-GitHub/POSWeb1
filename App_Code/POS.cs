using System;
using System.Collections.Generic;
using System.Data;
using System.Net.NetworkInformation;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using APIsDLLUtility;
using DllLogin;
using DLLOrderMaster;
using DLLPayout;
using Newtonsoft.Json;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]
public class POS : System.Web.Services.WebService
{

    public POS()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod(EnableSession = true)]
    public string AddToCart(string dataValues)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValues);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.SKUAutoId = Convert.ToInt32(jdv["SKUAutoId"]);
                pobj.CustomerId = Convert.ToInt32(jdv["CustomerId"]);
                pobj.OrderNo = jdv["OrderNo"];
                pobj.OrderId = Convert.ToInt32(jdv["OrderId"]);
                pobj.SKUName = jdv["SKUName"];
                pobj.SKUAmt = Convert.ToDecimal(jdv["SKUAmt"]);
                pobj.GiftCardCode = jdv["GiftCardCode"];
                pobj.Quantity = Convert.ToInt32(jdv["Quantity"]);
                pobj.MinAge = Convert.ToInt32(jdv["Age"]);
                pobj.CartItemId = Convert.ToInt32(jdv["CartItemId"]);
                pobj.TerminalId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                pobj.ShiftId = Convert.ToInt32(HttpContext.Current.Session["ShiftId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BL_orderMaster.AddToCart(pobj);
                if (!pobj.isException)
                {
                    string res = "";
                    if (pobj.Ds.Tables.Count > 0)
                    {
                        if (pobj.Ds.Tables[0].Rows.Count > 0)
                        {
                            foreach (DataRow row in pobj.Ds.Tables[0].Rows)
                            {
                                res += row[0].ToString();
                            }
                        }
                    }
                    return res;
                    
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

    [WebMethod(EnableSession = true)]
    public string AddDiscount(string dataValues)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValues);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Discount = Convert.ToDecimal(jdv["Discount"]);
                pobj.Type = jdv["Type"];
                pobj.OrderNo = jdv["OrderNo"];
                pobj.CustomerId = Convert.ToInt32(jdv["CustomerId"]);
                pobj.TerminalId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                pobj.ShiftId = Convert.ToInt32(HttpContext.Current.Session["ShiftId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BL_orderMaster.AddDiscount(pobj);
                if (!pobj.isException)
                {
                    string res = "";
                    if (pobj.Ds.Tables.Count > 0)
                    {
                        if (pobj.Ds.Tables[0].Rows.Count > 0)
                        {
                            foreach (DataRow row in pobj.Ds.Tables[0].Rows)
                            {
                                res += row[0].ToString();
                            }
                        }
                    }
                    return res;

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

    [WebMethod(EnableSession = true)]
    public string RemoveDiscount(string dataValues)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValues);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {  
                pobj.OrderNo = jdv["OrderNo"];
                pobj.CustomerId = Convert.ToInt32(jdv["CustomerId"]);
                pobj.TerminalId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.ShiftId = Convert.ToInt32(HttpContext.Current.Session["ShiftId"]);
                BL_orderMaster.RemoveDiscount(pobj);
                if (!pobj.isException)
                {
                    string res = "";
                    if (pobj.Ds.Tables.Count > 0)
                    {
                        if (pobj.Ds.Tables[0].Rows.Count > 0)
                        {
                            foreach (DataRow row in pobj.Ds.Tables[0].Rows)
                            {
                                res += row[0].ToString();
                            }
                        }
                    }
                    return res;

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

    [WebMethod(EnableSession = true)]
    public string GetCart(string dataValues)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValues);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.OrderNo = jdv["OrderNo"];
                pobj.OrderId = Convert.ToInt32(jdv["OrderId"]);
                pobj.CustomerId = Convert.ToInt32(jdv["CustomerId"]);             
                pobj.TerminalId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.ShiftId = Convert.ToInt32(HttpContext.Current.Session["ShiftId"]);
                BL_orderMaster.GetCart(pobj);
                if (!pobj.isException)
                {
                    string res = "";
                    if (pobj.Ds.Tables.Count > 0)
                    {
                        if (pobj.Ds.Tables[0].Rows.Count > 0)
                        {
                            foreach (DataRow row in pobj.Ds.Tables[0].Rows)
                            {
                                res += row[0].ToString();
                            }
                        }
                    }
                    return res;

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

    [WebMethod(EnableSession = true)]
    public string DeleteProductFromCart(string dataValues)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValues);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.CartItemId = Convert.ToInt32(jdv["CartItemId"]);
                pobj.CustomerId = Convert.ToInt32(jdv["CustomerId"]);
                pobj.OrderNo = jdv["OrderNo"];
                pobj.OrderId = Convert.ToInt32(jdv["OrderId"]);               
                pobj.TerminalId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.ShiftId = Convert.ToInt32(HttpContext.Current.Session["ShiftId"]);
                BL_orderMaster.DeleteProductFromCart(pobj);
                if (!pobj.isException)
                {
                    string res = "";
                    if (pobj.Ds.Tables.Count > 0)
                    {
                        if (pobj.Ds.Tables[0].Rows.Count > 0)
                        {
                            foreach (DataRow row in pobj.Ds.Tables[0].Rows)
                            {
                                res += row[0].ToString();
                            }
                        }
                    }
                    return res;

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

    [WebMethod(EnableSession = true)]
    public string AddGiftCard(string dataValues)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValues);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                if (jdv["DOB"] != "")
                {
                    pobj.DOB = Convert.ToDateTime(jdv["DOB"]);
                }
                pobj.OrderNo = jdv["OrderNo"];
                pobj.SKUName = jdv["SKUName"];
                pobj.GiftCardNo = jdv["GiftCardNo"];
                pobj.GiftCardAmt = Convert.ToDecimal(jdv["GiftCardAmt"]);
                pobj.FirstName = jdv["FirstName"];
                pobj.LastName = jdv["LastName"];
                pobj.MobileNo = jdv["MobileNo"];
                pobj.EmailId = jdv["EmailId"];
                pobj.Address = jdv["Address"];
                pobj.City = jdv["City"];
                pobj.State = Convert.ToInt32(jdv["State"]);
                pobj.ZipCode = jdv["ZipCode"];
                pobj.Quantity = Convert.ToInt32(jdv["Quantity"]);
                pobj.CustomerId = Convert.ToInt32(jdv["CustomerId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.TerminalId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                pobj.ShiftId = Convert.ToInt32(HttpContext.Current.Session["ShiftId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BL_orderMaster.AddGiftCard(pobj);
                if (!pobj.isException)
                {
                    string res = "";
                    if (pobj.Ds.Tables.Count > 0)
                    {
                        if (pobj.Ds.Tables[0].Rows.Count > 0)
                        {
                            foreach (DataRow row in pobj.Ds.Tables[0].Rows)
                            {
                                res += row[0].ToString();
                            }
                        }
                    }
                    return res;
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

    [WebMethod(EnableSession = true)]
    public string GetBarCodeDetails(string dataValues)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValues);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Barcode = jdv["Barcode"];
                pobj.CustomerId = Convert.ToInt32(jdv["CustomerId"]);
                pobj.ProductAutoId = Convert.ToInt32(jdv["ProductAutoId"]);
                pobj.Quantity = Convert.ToInt32(jdv["Quantity"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BL_orderMaster.BindByBarcode(pobj);
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

    [WebMethod(EnableSession = true)]
    public string InsertScreen(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.ScreenName = jdv["ScreenName"];
                pobj.Status = Convert.ToInt32(jdv["Status"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BL_orderMaster.InsertScreen(pobj);
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
            return ex.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    public string UpdateScreen(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.ScreenId = Convert.ToInt32(jdv["ScreenId"]);
                pobj.ScreenName = jdv["ScreenName"];
                pobj.Status = Convert.ToInt32(jdv["Status"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BL_orderMaster.UpdateScreen(pobj);
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
            return ex.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    public string GetScreen(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.ScreenName = jdv["ScreenName"];
                pobj.Status = Convert.ToInt32(jdv["Status"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                BL_orderMaster.GetScreen(pobj);
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
            return ex.Message;
        }

    }

    [WebMethod(EnableSession = true)]
    public string DeleteScreen(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.ScreenId = Convert.ToInt32(jdv["ScreenId"]);
                BL_orderMaster.DeleteScreen(pobj);
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
            return ex.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    public string BindSKUByProduct(string dataValues)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValues);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.ProductAutoId = Convert.ToInt32(jdv["ProductAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BL_orderMaster.BindSKUByProduct(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }

    }

    [WebMethod(EnableSession = true)]
    public string BindSKUByBarcode(string dataValues)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValues);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Barcode = jdv["Barcode"];
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BL_orderMaster.BindSKUByBarcode(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }

    }

    [WebMethod(EnableSession = true)]
    public string CurrentUserType()
    {
        string EmpType = "";


        if (HttpContext.Current.Session["EmpTypeNo"] != null)
        {
            EmpType = Convert.ToString(HttpContext.Current.Session["EmpTypeNo"]);

            if (EmpType != "")
            {
                return EmpType;
            }
            else
            {
                return EmpType;
            }
        }
        else
        {
            return EmpType;
        }
    }

    [WebMethod(EnableSession = true)]
    public string BindProductList(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {

                pobj.ProductName = jdv["ProductName"];
                pobj.Fav = Convert.ToInt32(jdv["Fav"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BL_orderMaster.BindProductList(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    public string ResetCart(string dataValues)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValues);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.OrderId = Convert.ToInt32(jdv["OrderId"]);
                pobj.OrderNo = jdv["OrderNo"];
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.TerminalId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BL_orderMaster.ResetCart(pobj);
                if (!pobj.isException)
                {
                    return "success";
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
            return ex.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    public string BindScreenProduct(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.ScreenId = Convert.ToInt32(jdv["ScreenId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BL_orderMaster.BindScreenProduct(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    public string SaveDraft(string dataValues)
    {
        if (HttpContext.Current.Session["EmpAutoId"] != null)
        {           
            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValues);
            PL_orderMaster pobj = new PL_orderMaster();
            try
            {
                if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
                {
                    pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                    pobj.TerminalId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                    pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                    pobj.DraftName = jdv["DraftName"];
                    pobj.CustomerId = Convert.ToInt32(jdv["CustomerId"]);
                    pobj.OrderNo = jdv["OrderNo"];
                    pobj.OrderId = Convert.ToInt32(jdv["OrderId"]);

                    BL_orderMaster.DraftOrder(pobj);
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
    [WebMethod(EnableSession = true)]
    public string GetDraftDetail(string dataValues)
    {
        if (HttpContext.Current.Session["EmpAutoId"] != null)
        {           
            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValues);
            PL_orderMaster pobj = new PL_orderMaster();
            try
            {
                if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
                {
                    pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                    pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                    pobj.OrderNo = jdv["OrderNo"];
                    pobj.OrderId = Convert.ToInt32(jdv["OrderId"]);
                    BL_orderMaster.GetDraftDetail(pobj);
                    if (!pobj.isException)
                    {
                        return pobj.Ds.GetXml(); ;
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

    [WebMethod(EnableSession = true)]
    public string UpdateDraft(string dataValues, string TableValues)
    {
        if (HttpContext.Current.Session["EmpAutoId"] != null)
        {
            DataTable dt = new DataTable();
            dt = JsonConvert.DeserializeObject<DataTable>(TableValues);
            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValues);
            PL_orderMaster pobj = new PL_orderMaster();
            try
            {
                if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
                {
                    if (dt.Rows.Count > 0)
                    {
                        pobj.TableValue = dt;
                    }
                    pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                    pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                    pobj.DraftAutoId = Convert.ToInt32(jdv["DraftId"]);
                    pobj.DraftName = jdv["DraftName"];
                    pobj.CustomerId = Convert.ToInt32(jdv["CustomerId"]);
                    pobj.OpeningBalance = Convert.ToDecimal(jdv["totalPrice"]);
                    pobj.Discount = Convert.ToDecimal(jdv["Discount"]);
                    pobj.DraftType = jdv["DraftType"];
                    BL_orderMaster.UpdateDraft(pobj);
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

    [WebMethod(EnableSession = true)]
    public string deleteDraftItem(string OrderNo)
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.OrderNo = OrderNo;
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BL_orderMaster.deleteDraftItem(pobj);
                if (!pobj.isException)
                {
                    return "true";
                    //return pobj.Ds.GetXml();
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
            return ex.Message;
        }
    }
    [WebMethod(EnableSession = true)]
    public string BindOrderDraftLogList()
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.TerminalId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BL_orderMaster.DraftOrderLog(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    public string BindDraftOrder(int DraftAutoId)
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.DraftAutoId = DraftAutoId;
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BL_orderMaster.BindDraftOrder(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    public string BindCardType()
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BL_orderMaster.BindCardType(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    public string bindDropdown()
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BL_orderMaster.BindAllDropDowns(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    public string bindDepartment()
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BL_orderMaster.BindDepartment(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    public string bindScreen()
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BL_orderMaster.bindScreen(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    public string bindPayoutType()
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                BL_orderMaster.bindPayoutType(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    public string bindVendor()
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BL_orderMaster.bindVendor(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }
    [WebMethod(EnableSession = true)]
    public string bindExpenses()
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BL_orderMaster.bindExpenses(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    public string AddCustomer(string dataValues)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValues);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                if (jdv["DOB"] != "")
                {
                    pobj.DOB = Convert.ToDateTime(jdv["DOB"]);
                }
                pobj.FirstName = jdv["FirstName"];
                pobj.LastName = jdv["LastName"];
                pobj.MobileNo = jdv["MobileNo"];
                pobj.EmailId = jdv["EmailId"];
                pobj.Address = jdv["Address"];
                pobj.City = jdv["City"];
                pobj.State = Convert.ToInt32(jdv["State"]);
                pobj.ZipCode = jdv["ZipCode"];
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BL_orderMaster.AddCustomer(pobj);
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

    [WebMethod(EnableSession = true)]
    public string SearchCustomer(string dataValues)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValues);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.FirstName = jdv["Name"];
                pobj.CustomerIdG = jdv["CustomerId"];
                pobj.MobileNo = jdv["MobileNo"];
                pobj.EmailId = jdv["EmailId"];
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.PageIndex = Convert.ToInt32(jdv["pageIndex"]);
                pobj.PageSize = Convert.ToInt32(jdv["PageSize"]);
                BL_orderMaster.SearchCustomer(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }

    #region Add To Home
    [WebMethod(EnableSession = true)]
    public string AddToHomeProduct(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.ScreenId = Convert.ToInt32(jdv["ScreenId"]);
                pobj.ProductName = jdv["ProductName"];
                pobj.Department = Convert.ToInt32(jdv["Department"]);
                pobj.PageIndex = Convert.ToInt32(jdv["PageIndex"]);
                pobj.PageSize = Convert.ToInt32(jdv["pageSize"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BL_orderMaster.AddToHomeProduct(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }
    #endregion Add To Home

    #region Add/Remove from favorite
    [WebMethod(EnableSession = true)]
    public string AddToProductScreen(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.ScreenId = Convert.ToInt32(jdv["ScreenId"]);
                pobj.ProductAutoId = Convert.ToInt32(jdv["ProductAutoId"]);
                pobj.Type = jdv["Type"];
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BL_orderMaster.AddToProductScreen(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    public string AddToFavorite(string ProductAutoId)
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.ProductAutoId = Convert.ToInt32(ProductAutoId);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BL_orderMaster.AddToFavorite(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }
    #endregion Add/Remove from favorite

    [WebMethod(EnableSession = true)]
    public string GenerateInvoice(string dataValues, string TransactionTableValues)
    {
        if (HttpContext.Current.Session["EmpAutoId"] != null)
        {
            //DataTable dt = new DataTable();
            //dt = JsonConvert.DeserializeObject<DataTable>(InvoiceTableValues);

            DataTable Transdt = new DataTable();
            Transdt = JsonConvert.DeserializeObject<DataTable>(TransactionTableValues);

            var jss = new JavaScriptSerializer();
            var jdv = jss.Deserialize<dynamic>(dataValues);
            PL_orderMaster pobj = new PL_orderMaster();
            try
            {
                if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
                {
                    //if (dt.Rows.Count > 0)
                    //{
                    //    pobj.DT_SaleSku = dt;
                    //}
                    if (Transdt.Rows.Count > 0)
                    {
                        pobj.DT_Transaction = Transdt;
                    }
                    pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                    pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                    pobj.CustomerId = Convert.ToInt32(jdv["CustomerId"]);
                    pobj.ShiftId = Convert.ToInt32(HttpContext.Current.Session["ShiftId"]);
                    pobj.Discount = Convert.ToDecimal(jdv["Discount"]);
                    pobj.TerminalId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]); 
                    pobj.CouponAmt = Convert.ToDecimal(jdv["CouponAmt"]);
                    pobj.CouponCode = jdv["CouponCode"];
                    pobj.GiftCardNo = jdv["GIftCardCode"];
                    pobj.GiftCardAmt = Convert.ToDecimal(jdv["GiftCardAmt"]);
                    pobj.LeftAmt = Convert.ToDecimal(jdv["LeftAmt"]);
                    pobj.GiftCardLftAmt = Convert.ToDecimal(jdv["GiftCardLeftAmt"]);
                    pobj.GiftCardUsedAmt = Convert.ToDecimal(jdv["GiftCardUsedAmt"]);
                    pobj.RoyaltyAmount = Convert.ToDecimal(jdv["RoyaltyAmount"]);
                    pobj.UsedRoyaltyPoints = Convert.ToInt32(jdv["UsedRoyaltyPoints"]);
                    pobj.DraftAutoId = Convert.ToInt32(jdv["DraftId"]);
                    pobj.PaymentMethod = jdv["PaymentMode"];
                    pobj.TransactionId = jdv["TransactionID"];
                    pobj.OrderNo = jdv["OrderNo"];
                    pobj.OrderId = Convert.ToInt32(jdv["OrderId"]);
                    pobj.TransactionId = jdv["TransactionID"];
                    pobj.CreditCardLastFourDigits = jdv["CreditCardLastfourDigit"];
                    pobj.CardType = Convert.ToInt32(jdv["CardTypeId"]);
                    //pobj.SoldGiftCardList = jdv["SoldGiftCardList"];
                    BL_orderMaster.InsertInvoice(pobj);
                    if (!pobj.isException)
                    {
                        return pobj.Ds.Tables[0].Rows[0]["InvoiceAutoId"].ToString();
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
                return pobj.exceptionMessage;
            }
        }
        else
        {
            return "Session";
        }
    }

    [WebMethod(EnableSession = true)]
    public string Print_Invoice(int InvoiceAutoId)
    {
        if (HttpContext.Current.Session["EmpAutoId"] != null)
        {
            PL_orderMaster pobj = new PL_orderMaster();
            try
            {
                if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
                {
                    pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                    pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                    pobj.InvoiceAutoId = Convert.ToInt32(InvoiceAutoId);
                    BL_orderMaster.Print_Invoice(pobj);
                    if (!pobj.isException)
                    {
                        string str = "";
                        foreach (DataRow dr in pobj.Ds.Tables[0].Rows)
                        {
                            str += dr[0];
                        }
                        return str;
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
    [WebMethod(EnableSession = true)]
    public string LoginAsAdmin(string password)
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            string CashierLogin = "";
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.SecuirtyCode = password;
                BL_orderMaster.LoginAsAdmin(pobj);
                if (!pobj.isException)
                {
                    CashierLogin = "YES";
                    if (pobj.Ds.Tables[0].Rows.Count > 0)
                    {
                        HttpContext.Current.Session.Add("CashierLogin", CashierLogin);
                        return pobj.Ds.GetXml();
                    }
                    else
                    {
                        return pobj.exceptionMessage.ToString();
                    }
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

    [WebMethod(EnableSession = true)]
    public string GiveDiscount(string password)
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.SecuirtyCode = password;
                BL_orderMaster.GiveDiscount(pobj);
                if (!pobj.isException)
                {
                    return pobj.exceptionMessage.ToString();
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
    [WebMethod(EnableSession = true)]
    public string WithdrawSecurity(string password)
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.SecuirtyCode = password;
                BL_orderMaster.WithdrawSecurity(pobj);
                if (!pobj.isException)
                {
                    return pobj.exceptionMessage.ToString();
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

    [WebMethod(EnableSession = true)]
    public string BalanceStatus2()
    {
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                if (HttpContext.Current.Session["EmpType"].ToString() == "Cashier")
                {
                    string BalanceStatus = "",Shift="";
                    int pageLoadCnt = 0;
                    pageLoadCnt = Convert.ToInt32(HttpContext.Current.Session["PageLoadCnt"]);
                    if (Convert.ToInt32(HttpContext.Current.Session["PageLoadCnt"]) == 0)
                    {
                        if (Convert.ToInt32(HttpContext.Current.Session["BreakPopUp"]) != 1)
                        {
                            BalanceStatus = HttpContext.Current.Session["BalanceStatus"].ToString();
                        }
                        //BalanceStatus = HttpContext.Current.Session["BalanceStatus"].ToString();
                        Shift = HttpContext.Current.Session["ShiftId"].ToString();
                        HttpContext.Current.Session.Add("PageLoadCnt", Convert.ToInt32(HttpContext.Current.Session["PageLoadCnt"]) + 1);
                        DataTable table = new DataTable("BalanceStatus");
                        table.Columns.Add("ShiftId");
                        table.Columns.Add("Status");
                        table.Rows.Add(Shift, BalanceStatus);
                        DataSet set = new DataSet();
                        set.Tables.Add(table);
                        return set.GetXml();
                    }
                    else
                    {
                        HttpContext.Current.Session.Add("PageLoadCnt", Convert.ToInt32(HttpContext.Current.Session["PageLoadCnt"]) + 1);
                        DataTable table = new DataTable("BalanceStatus");
                        table.Columns.Add("ShiftId");
                        table.Columns.Add("Status");
                        table.Rows.Add(HttpContext.Current.Session["ShiftId"].ToString(), "PageLoadMoreThanOnce");
                        DataSet set = new DataSet();
                        set.Tables.Add(table);
                        return set.GetXml();
                    }
                }
                else
                {
                    return "Admin";
                }
            }
            else
            {
                return "Session";
            }
        }
        catch (Exception ex)
        {
            return ex.Message.ToString();
        }
    }
    [WebMethod(EnableSession = true)]
    public string OpeningBalance(string dataValues, string Currencydatatable)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValues);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                DataTable CurrencyTable = new DataTable();
                CurrencyTable = JsonConvert.DeserializeObject<DataTable>(Currencydatatable);
                if (CurrencyTable.Rows.Count > 0)
                {
                    pobj.CurrencyTable = CurrencyTable;
                }
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.TerminalId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                pobj.BalanceStatus = HttpContext.Current.Session["BalanceStatus"].ToString();
                pobj.OpeningBalance = Convert.ToDecimal(jdv["ClosingBalance"]);
                BL_orderMaster.OpeningBalance(pobj);
                if (!pobj.isException)
                {
                    HttpContext.Current.Session.Add("BalanceStatus", "Break");
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
            pobj.exceptionMessage = ex.Message;
            return pobj.exceptionMessage;
        }
    }
    [WebMethod(EnableSession = true)]
    public string ClosingBalance(string dataValues, string Currencydatatable)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValues);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                DataTable CurrencyTable = new DataTable();
                CurrencyTable = JsonConvert.DeserializeObject<DataTable>(Currencydatatable);
                if (CurrencyTable.Rows.Count > 0)
                {
                    pobj.CurrencyTable = CurrencyTable;
                }
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.BalanceStatus = HttpContext.Current.Session["BalanceStatus"].ToString();
                pobj.TerminalId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                pobj.ClosingBalance = Convert.ToDecimal(jdv["ClosingBalance"]);
                pobj.CurrentBalStatus = jdv["CurrentBalStatus"];
                pobj.CurrentBalance = Convert.ToDecimal(jdv["CurrentBalance"]);
                BL_orderMaster.ClosingBalance(pobj);
                if (!pobj.isException)
                {
                    HttpContext.Current.Session.Add("BreakPopUp", 0);
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
            pobj.exceptionMessage = ex.Message;
            return pobj.exceptionMessage;
        }
    }
    [WebMethod(EnableSession = true)]
    public string NoSale(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Remark = jdv["NoSaleRemark"];
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.TerminalId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                BL_orderMaster.NoSale(pobj);
                if (!pobj.isException)
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
            pobj.exceptionMessage = ex.Message;
            return pobj.exceptionMessage;
        }
    }
    [WebMethod(EnableSession = true)]
    public string getComName()
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                string ComName = "", EmpName = "", TerminalName="";
                ComName = HttpContext.Current.Session["CompanyName"].ToString();
                EmpName = Convert.ToString(HttpContext.Current.Session["EmpFirstName"]);
                TerminalName = Convert.ToString(HttpContext.Current.Session["TerminalName"]);

                DataTable table1 = new DataTable("Table");
                table1.Columns.Add("CompanyName");
                table1.Columns.Add("EmployeeName");
                table1.Columns.Add("TerminalName");
                if (HttpContext.Current.Session["EmpFirstName"] != null)
                {
                    table1.Rows.Add(ComName, EmpName, TerminalName);
                }
                else
                {
                    table1.Rows.Add(ComName, "","");
                }
                //table1.Rows.Add("mark", 2);

                //DataTable table2 = new DataTable("medications");
                //table2.Columns.Add("id");
                //table2.Columns.Add("medication");
                //table2.Rows.Add(1, "atenolol");
                //table2.Rows.Add(2, "amoxicillin");

                // Create a DataSet and put both tables in it.
                DataSet set = new DataSet();
                set.Tables.Add(table1);
                //set.Tables.Add(table2);

                // Visualize DataSet.
                return set.GetXml();
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
    [WebMethod(EnableSession = true)]
    public string GetUserTypeId()
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (System.Web.HttpContext.Current.Session["EmpAutoId"] != null)
            {
                return HttpContext.Current.Session["EmpTypeNo"].ToString();
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

    [WebMethod(EnableSession = true)]
    public string editScreen(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.ScreenId = Convert.ToInt32(jdv["ScreenId"]);
                BL_orderMaster.editScreen(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    public string BindCurrencyList()
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.ShiftId = Convert.ToInt32(HttpContext.Current.Session["ShiftId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.TerminalId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                BL_orderMaster.BindCurrencyList(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    public string BindCurrentCash()
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.ShiftId = Convert.ToInt32(HttpContext.Current.Session["ShiftId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.TerminalId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                BL_orderMaster.BindCurrentCash(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    public string BindClosCurrencyList()
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.TerminalId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                BL_orderMaster.BindClosCurrencyList(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    public string ApplyCoupon(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.TotalAmt = Convert.ToDecimal(jdv["TotalAmt"]);
                pobj.CouponCode = jdv["CouponCode"];
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BL_orderMaster.ApplyCoupon(pobj);
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

    [WebMethod(EnableSession = true)]
    public string ClockIn(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Remark = jdv["Remark"];
                pobj.DateTime = jdv["DateTime"];
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BL_orderMaster.ClockIn(pobj);
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

    [WebMethod(EnableSession = true)]
    public string ClockOut(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Remark = jdv["Remark"];
                pobj.DateTime = jdv["DateTime"];
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BL_orderMaster.ClockOut(pobj);
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

    [WebMethod(EnableSession = true)]
    public string CheckClockInOut()
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                BL_orderMaster.CheckClockInOut(pobj);
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

    [WebMethod(EnableSession = true)]
    public string SaveDeposit(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Remark = jdv["Remark"];
                pobj.PaidAmount = Convert.ToDecimal(jdv["Amount"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.ShiftId = Convert.ToInt32(HttpContext.Current.Session["ShiftId"]);
                pobj.TerminalId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                BL_orderMaster.SaveDeposit(pobj);
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

    [WebMethod(EnableSession = true)]
    public string Print_SafeCash(int AutoId)
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.BalanceAutoId = Convert.ToInt32(AutoId);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.ShiftId = Convert.ToInt32(HttpContext.Current.Session["ShiftId"]);
                pobj.TerminalId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                BL_orderMaster.Print_SafeCash(pobj);
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

    [WebMethod(EnableSession = true)]
    public string SaveWithdraw(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Remark = jdv["Remark"];
                pobj.PaidAmount = Convert.ToDecimal(jdv["Amount"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.ShiftId = Convert.ToInt32(HttpContext.Current.Session["ShiftId"]);
                pobj.TerminalId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                BL_orderMaster.SaveWithdraw(pobj);
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

    [WebMethod(EnableSession = true)]
    public string FillCustomerDetails(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.CustomerId = Convert.ToInt32(jdv["CustomerId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BL_orderMaster.FillCustomerDetails(pobj);
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

    [WebMethod(EnableSession = true)]
    public string RedeemGiftCard(string dataValue)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.GiftCardNo = jdv["GiftCardNo"];
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BL_orderMaster.RedeemGiftCard(pobj);
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

    [WebMethod(EnableSession = true)]
    public string GetRoyaltyRedeemCriteria()
    {
        var jss = new JavaScriptSerializer();
        //var jdv = jss.Deserialize<dynamic>(dataValue);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BL_orderMaster.GetRoyaltyRedeemCriteria(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    public string CheckStore()
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BL_orderMaster.CheckStore(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }
    [WebMethod(EnableSession = true)]
    public string BreakLog()
    {
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                pobj.ShiftId = Convert.ToInt32(HttpContext.Current.Session["ShiftId"]);
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.TerminalId = Convert.ToInt32(HttpContext.Current.Session["TerminalAutoId"]);
                BL_orderMaster.BreakLog(pobj);
                if (!pobj.isException)
                {
                    return pobj.exceptionMessage.ToString();
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
            return ex.Message;
        }
    }
    [WebMethod(EnableSession = true)]
    public string CreateTransactionLog(string dataValues)
    {
        var jss = new JavaScriptSerializer();
        var jdv = jss.Deserialize<dynamic>(dataValues);
        PL_orderMaster pobj = new PL_orderMaster();
        try
        {
            if (HttpContext.Current.Session["EmpAutoId"] != null)
            {
                pobj.CustomerId = Convert.ToInt32(jdv["CustomerId"]);
                pobj.DraftAutoId = Convert.ToInt32(jdv["DraftId"]);
                pobj.InvoiceNo = jdv["InvoiceNo"];
                pobj.CardType = Convert.ToInt32(jdv["CardType"]);
                pobj.CardNo = jdv["CardNo"];
                pobj.TransactionId = jdv["TransactionId"];
                pobj.TotalAmt = Convert.ToDecimal(jdv["ProceedAmt"]);
                pobj.TrnsStatus = jdv["Status"];
                pobj.Who = Convert.ToInt32(HttpContext.Current.Session["EmpAutoId"]);
                pobj.StoreId = Convert.ToInt32(HttpContext.Current.Session["StoreId"]);
                BL_orderMaster.CreateTransactionLog(pobj);
                if (!pobj.isException)
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
            return ex.Message;
        }
    }
    
}

