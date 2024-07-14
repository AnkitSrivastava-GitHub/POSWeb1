using System;
using System.Data;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using APIsDLLUtility;
using Newtonsoft.Json;
using DLL_APILogin;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using DLL_ProductListAPI;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]
public class CashierActionPopUp : System.Web.Services.WebService
{
    public CashierActionPopUp()
    {
        API_gZipCompression.fn_gZipCompression();
    }

    [WebMethod]                //.............................................API GetActionButtonList- List of Action Buttons
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object GetActionButtonList(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("GetActionButtonList", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.GetActionButtonList(pobj);
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
                        objResponse.responseMessage = "Success";
                        objResponse.responseCode = "200";
                        JavaScriptSerializer j = new JavaScriptSerializer();
                        j.MaxJsonLength = 999999999;
                        objResponse.responseData = j.Deserialize(res, typeof(object));
                    }
                }
                else
                {
                    objResponse.responseMessage = pobj.exceptionMessage;
                    objResponse.responseCode = pobj.responseCode;
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                //.............................................API GetScreenList- List of Screen
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object GetScreenList(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("GetScreenList", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.SearchString = requestData.SearchString;
            pobj.Status = requestData.Status;
            pobj.StoreId = requestData.StoreId;
            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.GetScreenList(pobj);
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
                        objResponse.responseMessage = "Success";
                        objResponse.responseCode = "200";
                        JavaScriptSerializer j = new JavaScriptSerializer();
                        j.MaxJsonLength = 999999999;
                        objResponse.responseData = j.Deserialize(res, typeof(object));
                    }
                }
                else
                {
                    objResponse.responseMessage = pobj.exceptionMessage;
                    objResponse.responseCode = pobj.responseCode;
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]  //.....................API InsertUpdateDeleteScreen- Insert Update and Delete Screen, All these operation working via Action (1.Insert, 2.Update, 3.Delete). 
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object InsertUpdateDeleteScreen(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("InsertUpdateDeleteScreen", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.ScreenName = requestData.ScreenName;
            pobj.Status = requestData.Status;
            pobj.StoreId = requestData.StoreId;
            pobj.Action = requestData.Action;
            pobj.ScreenAutoId = requestData.ScreenAutoId;
            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.SaveScreen(pobj);
            if (!pobj.isException)
            {
                objResponse.responseData = "";
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]         //...........................................API NoSale - Save Remark for NoSale
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object NoSale(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("InsertUpdateDeleteScreen", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.TerminalId = requestData.TerminalId;
            pobj.Remark = requestData.Remark;
            pobj.Action = requestData.Action;
            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.NoSale(pobj);
            if (!pobj.isException)
            {
                objResponse.responseData = "";
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]         //...........................................API GetAddToScreenProductList - Add To Screen Product List
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object GetAddToScreenProductList(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("InsertUpdateDeleteScreen", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.SearchString = requestData.SearchString;
            pobj.Department = requestData.Department;
            pobj.ScreenId = requestData.ScreenId;
            pobj.Action = requestData.Action;
            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.GetAddToScreenProductList(pobj);
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
                        objResponse.responseMessage = "Success";
                        objResponse.responseCode = "200";
                        JavaScriptSerializer j = new JavaScriptSerializer();
                        j.MaxJsonLength = 999999999;
                        objResponse.responseData = j.Deserialize(res, typeof(object));
                    }
                }
                else
                {
                    objResponse.responseMessage = pobj.exceptionMessage;
                    objResponse.responseCode = pobj.responseCode;
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                  //...........................................API GetEndShiftDetails - Get End Shift Details
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object GetEndShiftDetails(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("GetEndShiftDetails", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.ShiftId = requestData.ShiftId;
            pobj.TerminalId = requestData.TerminalId;
            //pobj.TestMode = pobj.LoginId.Substring((pobj.LoginId.IndexOf("@")) + 1);
            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.GetEndShiftDetails(pobj);
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
                        objResponse.responseMessage = "Success";
                        objResponse.responseCode = "200";
                        JavaScriptSerializer j = new JavaScriptSerializer();
                        j.MaxJsonLength = 999999999;
                        objResponse.responseData = j.Deserialize(res, typeof(object));
                    }
                }
                else
                {
                    objResponse.responseMessage = pobj.exceptionMessage;
                    objResponse.responseCode = pobj.responseCode;
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                    //...........................................API ProceedClosingDetails - Close Shift with All Details
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object ProceedClosingDetails(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("ProceedClosingDetails", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.TerminalId = requestData.TerminalId;
            pobj.BalanceStatus = requestData.BalanceStatus;
            pobj.ClosingBalance = requestData.ClosingBalance;
            pobj.CurrentBalanceStatus = requestData.CurrentBalanceStatus;
            pobj.CurrentBalance = requestData.CurrentBalance;
            pobj.ShiftId = requestData.ShiftId;
            if (requestData.CurrencyTable.Count > 0)
            {
                foreach (dtCurrencyTable item in requestData.CurrencyTable)
                {
                    DataRow dr = pobj.DT_CurrencyListChild.NewRow();
                    dr["CurrencyID"] = Convert.ToInt32(item.CurrencyID);
                    dr["QTY"] = Convert.ToInt32(item.QTY);
                    pobj.DT_CurrencyListChild.Rows.Add(dr);
                }
            }
            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.ProceedClosingDetails(pobj);
            if (!pobj.isException)
            {
                objResponse.responseData = "";
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                   //...........................................API AddProductToScreens - Add Products To Screens from Add To Screen 
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object AddProductToScreens(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("AddProductToScreens", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.ProductId = requestData.ProductId;
            pobj.Type = requestData.Type;
            pobj.ScreenId = requestData.ScreenId;

            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.AddProductToScreens(pobj);
            if (!pobj.isException)
            {
                objResponse.responseData = "";
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                   //...........................................API GetScreenProductList - Get Screen wise Product List 
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object GetScreenProductList(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("GetScreenProductList", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.ScreenId = requestData.ScreenId;

            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.GetScreenProductList(pobj);
            if (pobj.Ds.Tables.Count > 0)
            {
                string res = "";
                if (pobj.Ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow row in pobj.Ds.Tables[0].Rows)
                    {
                        res += row[0].ToString();
                    }
                    objResponse.responseMessage = "Success";
                    objResponse.responseCode = "200";
                    JavaScriptSerializer j = new JavaScriptSerializer();
                    j.MaxJsonLength = 999999999;
                    objResponse.responseData = j.Deserialize(res, typeof(object));
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                   //...........................................API GetMultiPackingProduct - Get Multiple Packing Product's - Packing Details 
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object GetMultiPackingProduct(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("GetMultiPackingProduct", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.SKUAutoId = requestData.SKUAutoId;
            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.GetMultiPackingProduct(pobj);
            if (pobj.Ds.Tables.Count > 0)
            {
                string res = "";
                if (pobj.Ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow row in pobj.Ds.Tables[0].Rows)
                    {
                        res += row[0].ToString();
                    }
                    objResponse.responseMessage = "Success";
                    objResponse.responseCode = "200";
                    JavaScriptSerializer j = new JavaScriptSerializer();
                    j.MaxJsonLength = 999999999;
                    objResponse.responseData = j.Deserialize(res, typeof(object));
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                   //...........................................API GetProductFromBarcode - Get Product From Barcode 
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object GetProductFromBarcode(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("GetProductFromBarcode", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.Barcode = requestData.Barcode;
            pobj.OrderNo = requestData.OrderNo;
            pobj.CustomerId = requestData.CustomerId;
            pobj.TerminalId = requestData.TerminalId;
            pobj.ShiftId = requestData.ShiftId;

            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.GetProductFromBarcode(pobj);
            if (pobj.Ds.Tables.Count > 0)
            {
                string res = "";
                if (pobj.Ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow row in pobj.Ds.Tables[0].Rows)
                    {
                        res += row[0].ToString();
                    }
                    objResponse.responseMessage = "Success";
                    objResponse.responseCode = "200";
                    JavaScriptSerializer j = new JavaScriptSerializer();
                    j.MaxJsonLength = 999999999;
                    objResponse.responseData = j.Deserialize(res, typeof(object));
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                   //...........................................API GetProductBySearch - Get Product Packing Details 
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object GetProductBySearch(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("GetProductBySearch", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.ProductName = requestData.ProductName;
            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.GetProductBySearch(pobj);
            if (pobj.Ds.Tables.Count > 0)
            {
                string res = "";
                if (pobj.Ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow row in pobj.Ds.Tables[0].Rows)
                    {
                        res += row[0].ToString();
                    }
                    objResponse.responseMessage = "Success";
                    objResponse.responseCode = "200";
                    JavaScriptSerializer j = new JavaScriptSerializer();
                    j.MaxJsonLength = 999999999;
                    objResponse.responseData = j.Deserialize(res, typeof(object));
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                   //...........................................API AddCustomer - Add New Customer 
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object AddCustomer(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("AddCustomer", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.FirstName = requestData.FirstName;
            pobj.LastName = requestData.LastName;
            pobj.MobileNo = requestData.MobileNo;
            pobj.EmailId = requestData.EmailId;
            pobj.Address = requestData.Address;
            pobj.City = requestData.City;
            pobj.State = requestData.State;
            pobj.ZipCode = requestData.ZipCode;
            pobj.DOB = requestData.DOB;
            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.AddCustomer(pobj);
            if (pobj.Ds.Tables.Count > 0)
            {
                string res = "";
                if (pobj.Ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow row in pobj.Ds.Tables[0].Rows)
                    {
                        res += row[0].ToString();
                    }
                    objResponse.responseMessage = "Success";
                    objResponse.responseCode = "200";
                    JavaScriptSerializer j = new JavaScriptSerializer();
                    j.MaxJsonLength = 999999999;
                    objResponse.responseData = j.Deserialize(res, typeof(object));
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                   //...........................................API GetCustomerList - Get Customer List  
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object GetCustomerList(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("GetCustomerList", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.FirstName = requestData.FirstName;
            pobj.CustomerIdV = requestData.CustomerIdV;
            pobj.MobileNo = requestData.MobileNo;
            pobj.EmailId = requestData.EmailId;
            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.GetCustomerList(pobj);
            if (pobj.Ds.Tables.Count > 0)
            {
                string res = "";
                if (pobj.Ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow row in pobj.Ds.Tables[0].Rows)
                    {
                        res += row[0].ToString();
                    }
                    objResponse.responseMessage = "Success";
                    objResponse.responseCode = "200";
                    JavaScriptSerializer j = new JavaScriptSerializer();
                    j.MaxJsonLength = 999999999;
                    objResponse.responseData = j.Deserialize(res, typeof(object));
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                   //...........................................API ClockInOut - Clock In Out  
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object ClockInOut(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("ClockInOut", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.Remark = requestData.Remark;
            pobj.DateTime = requestData.DateTime;
            pobj.SearchString = requestData.SearchString;
            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.ClockInOut(pobj);
            if (pobj.Ds.Tables.Count > 0)
            {
                string res = "";
                if (pobj.Ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow row in pobj.Ds.Tables[0].Rows)
                    {
                        res += row[0].ToString();
                    }
                    objResponse.responseMessage = "Success";
                    objResponse.responseCode = "200";
                    JavaScriptSerializer j = new JavaScriptSerializer();
                    j.MaxJsonLength = 999999999;
                    objResponse.responseData = j.Deserialize(res, typeof(object));
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                   //...........................................API AddGiftCard - Add Gift Card  
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object AddGiftCard(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("AddGiftCard", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.GiftCardNo = requestData.GiftCardNo;
            pobj.DOB = requestData.DOB;
            pobj.GiftCardAmt = requestData.GiftCardAmt;
            pobj.FirstName = requestData.FirstName;
            pobj.LastName = requestData.LastName;
            pobj.MobileNo = requestData.MobileNo;
            pobj.EmailId = requestData.EmailId;
            pobj.Address = requestData.Address;
            pobj.City = requestData.City;
            pobj.State = requestData.State;
            pobj.ZipCode = requestData.ZipCode;
            pobj.CustomerId = requestData.CustomerId;
            pobj.TerminalId = requestData.TerminalId;
            pobj.SKUName = requestData.SKUName;
            pobj.OrderNo = requestData.OrderNo;
            pobj.OrderId = requestData.OrderId;
            pobj.ShiftId = requestData.ShiftId;

            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.AddGiftCard(pobj);
            if (pobj.Ds.Tables.Count > 0)
            {
                string res = "";
                if (pobj.Ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow row in pobj.Ds.Tables[0].Rows)
                    {
                        res += row[0].ToString();
                    }
                    objResponse.responseMessage = "Success";
                    objResponse.responseCode = "200";
                    JavaScriptSerializer j = new JavaScriptSerializer();
                    j.MaxJsonLength = 999999999;
                    objResponse.responseData = j.Deserialize(res, typeof(object));
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                   //...........................................API ApplyGiftCard - Apply Gift Card  
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object ApplyGiftCard(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("ApplyGiftCard", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.GiftCardNo = requestData.GiftCardNo;
            pobj.CustomerId = requestData.CustomerId;

            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.ApplyGiftCard(pobj);
            if (pobj.Ds.Tables.Count > 0)
            {
                string res = "";
                if (pobj.Ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow row in pobj.Ds.Tables[0].Rows)
                    {
                        res += row[0].ToString();
                    }
                    objResponse.responseMessage = "Success";
                    objResponse.responseCode = "200";
                    JavaScriptSerializer j = new JavaScriptSerializer();
                    j.MaxJsonLength = 999999999;
                    objResponse.responseData = j.Deserialize(res, typeof(object));
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                   //...........................................API GetCouponDetails - Get Coupon Details  
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object GetCouponDetails(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("GetCouponDetails", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.CouponCode = requestData.CouponCode;
            pobj.TotalAmt = requestData.TotalAmt;
            pobj.OrderNo = requestData.OrderNo;
            pobj.OrderId = requestData.OrderId;
            pobj.TransactionAutoId = requestData.TransactionAutoId;

            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.GetCouponDetails(pobj);
            if (pobj.Ds.Tables.Count > 0)
            {
                string res = "";
                if (pobj.Ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow row in pobj.Ds.Tables[0].Rows)
                    {
                        res += row[0].ToString();
                    }
                    objResponse.responseMessage = "Success";
                    objResponse.responseCode = "200";
                    JavaScriptSerializer j = new JavaScriptSerializer();
                    j.MaxJsonLength = 999999999;
                    objResponse.responseData = j.Deserialize(res, typeof(object));
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                   //...........................................API GetCustomerDetails - Get Customer Details  
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object GetCustomerDetails(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("GetCustomerDetails", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.CustomerId = requestData.CustomerAutoId;

            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.GetCustomerDetails(pobj);
            if (pobj.Ds.Tables.Count > 0)
            {
                string res = "";
                if (pobj.Ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow row in pobj.Ds.Tables[0].Rows)
                    {
                        res += row[0].ToString();
                    }
                    objResponse.responseMessage = "Success";
                    objResponse.responseCode = "200";
                    JavaScriptSerializer j = new JavaScriptSerializer();
                    j.MaxJsonLength = 999999999;
                    objResponse.responseData = j.Deserialize(res, typeof(object));
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                //.............................................API GetPayNowButtonList- Get Pay Now Button List
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object GetPayNowButtonList(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("GetPayNowButtonList", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.GetPayNowButtonList(pobj);
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
                        objResponse.responseMessage = "Success";
                        objResponse.responseCode = "200";
                        JavaScriptSerializer j = new JavaScriptSerializer();
                        j.MaxJsonLength = 999999999;
                        objResponse.responseData = j.Deserialize(res, typeof(object));
                    }
                }
                else
                {
                    objResponse.responseMessage = pobj.exceptionMessage;
                    objResponse.responseCode = pobj.responseCode;
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                //.............................................API GetRewardPointDetails- Get Reward Point Details
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object GetRewardPointDetails(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("GetRewardPointDetails", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.CustomerId = requestData.CustomerId;

            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.GetRewardPointDetails(pobj);
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
                        objResponse.responseMessage = "Success";
                        objResponse.responseCode = "200";
                        JavaScriptSerializer j = new JavaScriptSerializer();
                        j.MaxJsonLength = 999999999;
                        objResponse.responseData = j.Deserialize(res, typeof(object));
                    }
                }
                else
                {
                    objResponse.responseMessage = pobj.exceptionMessage;
                    objResponse.responseCode = pobj.responseCode;
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                //.............................................API GetCreditCardList- Get Credit Card List
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object GetCreditCardList(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("GetCreditCardList", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;

            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.GetCreditCardList(pobj);
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
                        objResponse.responseMessage = "Success";
                        objResponse.responseCode = "200";
                        JavaScriptSerializer j = new JavaScriptSerializer();
                        j.MaxJsonLength = 999999999;
                        objResponse.responseData = j.Deserialize(res, typeof(object));
                    }
                }
                else
                {
                    objResponse.responseMessage = pobj.exceptionMessage;
                    objResponse.responseCode = pobj.responseCode;
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                //.............................................API GetSecurityPin- Get Security Pin
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object GetSecurityPin(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("GetSecurityPin", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.SearchString = requestData.SearchString;
            pobj.SecurityPin = requestData.SecurityPin;

            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.GetSecurityPin(pobj);
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
                        objResponse.responseMessage = "Success";
                        objResponse.responseCode = "200";
                        JavaScriptSerializer j = new JavaScriptSerializer();
                        j.MaxJsonLength = 999999999;
                        objResponse.responseData = j.Deserialize(res, typeof(object));
                    }
                }
                else
                {
                    objResponse.responseMessage = pobj.exceptionMessage;
                    objResponse.responseCode = pobj.responseCode;
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                //.............................................API GetSecurityPin- Get Security Pin
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object DraftOrder(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("DraftOrder", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.CustomerId = requestData.CustomerId;
            pobj.DraftName = requestData.DraftName;
            pobj.OrderNo = requestData.OrderNo;

            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.DraftOrder(pobj);
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
                        objResponse.responseMessage = "Success";
                        objResponse.responseCode = "200";
                        JavaScriptSerializer j = new JavaScriptSerializer();
                        j.MaxJsonLength = 999999999;
                        objResponse.responseData = j.Deserialize(res, typeof(object));
                    }
                }
                else
                {
                    objResponse.responseMessage = pobj.exceptionMessage;
                    objResponse.responseCode = pobj.responseCode;
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                //.............................................API DeleteDraftOrder- Delete Draft Order
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object DeleteDraftOrder(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("DeleteDraftOrder", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.OrderNo = requestData.OrderNo;
            pobj.DraftName = requestData.DraftName;

            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.DeleteDraftOrder(pobj);
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
                        objResponse.responseMessage = "Success";
                        objResponse.responseCode = "200";
                        JavaScriptSerializer j = new JavaScriptSerializer();
                        j.MaxJsonLength = 999999999;
                        objResponse.responseData = j.Deserialize(res, typeof(object));
                    }
                }
                else
                {
                    objResponse.responseMessage = pobj.exceptionMessage;
                    objResponse.responseCode = pobj.responseCode;
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                //.............................................API GetDraftList- Get Draft List
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object GetDraftList(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("GetDraftList", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.TerminalId = requestData.TerminalId;

            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.GetDraftList(pobj);
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
                        objResponse.responseMessage = "Success";
                        objResponse.responseCode = "200";
                        JavaScriptSerializer j = new JavaScriptSerializer();
                        j.MaxJsonLength = 999999999;
                        objResponse.responseData = j.Deserialize(res, typeof(object));
                    }
                }
                else
                {
                    objResponse.responseMessage = pobj.exceptionMessage;
                    objResponse.responseCode = pobj.responseCode;
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                //.............................................API Payout- Payout to vendor and for expense
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object Payout(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("Payout", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.TerminalId = requestData.TerminalId;
            pobj.Expense = requestData.Expense;
            pobj.Vendor = requestData.Vendor;
            pobj.PayoutDate = requestData.PayoutDate;
            pobj.PayoutTime = requestData.PayoutTime;
            pobj.PayoutTo = requestData.PayoutTo;
            pobj.Remark = requestData.Remark;
            pobj.TotalAmt = requestData.TotalAmt;
            pobj.PaymentMode = requestData.PaymentMode;
            pobj.PayoutType = requestData.PayoutType;
            pobj.ShiftId = requestData.ShiftId;

            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.Payout(pobj);
            if (!pobj.isException)
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
                objResponse.responseData = "";
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                //.............................................API GetPayoutList- Get Payout List
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object GetPayoutList(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("GetPayoutList", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.TerminalId = requestData.TerminalId;
            pobj.Expense = requestData.Expense;
            pobj.Vendor = requestData.Vendor;            
            pobj.PayoutTo = requestData.PayoutTo;
            pobj.TotalAmt = requestData.TotalAmt;
            pobj.PayoutType = requestData.PayoutType;

            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.GetPayoutList(pobj);
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
                        objResponse.responseMessage = "Success";
                        objResponse.responseCode = "200";
                        JavaScriptSerializer j = new JavaScriptSerializer();
                        j.MaxJsonLength = 999999999;
                        objResponse.responseData = j.Deserialize(res, typeof(object));
                    }
                }
                else
                {
                    objResponse.responseMessage = pobj.exceptionMessage;
                    objResponse.responseCode = pobj.responseCode;
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }

    [WebMethod]                   //...........................................API CashTransaction - Cash Transaction  
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object CashTransaction(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("CashTransaction", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_CashierActionPopUp.PL_CashierActionPopUp pobj = new global::DLL_CashierActionPopUp.PL_CashierActionPopUp();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;
            pobj.CashAmount = requestData.CashAmount;
            pobj.OrderNo = requestData.OrderNo;
            pobj.OrderId = requestData.OrderId;
            pobj.TransactionAutoId = requestData.TransactionAutoId;

            global::DLL_CashierActionPopUp.BAL_CashierActionPopUp.CashTransaction(pobj);
            if (pobj.Ds.Tables.Count > 0)
            {
                string res = "";
                if (pobj.Ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow row in pobj.Ds.Tables[0].Rows)
                    {
                        res += row[0].ToString();
                    }
                    objResponse.responseMessage = "Success";
                    objResponse.responseCode = "200";
                    JavaScriptSerializer j = new JavaScriptSerializer();
                    j.MaxJsonLength = 999999999;
                    objResponse.responseData = j.Deserialize(res, typeof(object));
                }
            }
            else
            {
                objResponse.responseMessage = pobj.exceptionMessage;
                objResponse.responseCode = pobj.responseCode;
            }
        }
        catch (Exception ex)
        {
            objResponse.responseMessage = "failed";
            objResponse.responseCode = "300";
        }
        return objResponse;
    }
}
