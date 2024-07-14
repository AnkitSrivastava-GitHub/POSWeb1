using System;
using System.Data;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using APIsDLLUtility;
using Newtonsoft.Json;
using DLL_APILogin;
using DLL_ProductListAPI;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using DLL_AddToCartAPI;

/// <summary>
/// Summary description for AddToCartAPI
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class AddToCartAPI : System.Web.Services.WebService
{

    public AddToCartAPI()
    {

        API_gZipCompression.fn_gZipCompression();
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object AddProductToCart(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("AddToCartAPI", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            PL_AddToCart pobj = new PL_AddToCart();
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
            pobj.SKUAutoId = requestData.SKUAutoId;
            pobj.Quantity = requestData.Quantity;
            pobj.OrderId = requestData.OrderId;
            pobj.OrderNo = requestData.OrderNo;
            pobj.SKUName = requestData.SKUName;
            pobj.CustomerId = requestData.CustomerId;
            pobj.Discount = requestData.Discount;
            pobj.SKUAmt = requestData.SKUAmt;
            pobj.GiftCardCode = requestData.GiftCardCode;
            pobj.ShiftId = requestData.ShiftId;
            pobj.CartItemId = requestData.CartItemId;

            //pobj.TestMode = pobj.LoginId.Substring((pobj.LoginId.IndexOf("@")) + 1);  CartItemId
            BAL_AddToCartAPI.AddProductToCart(pobj);
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

    [WebMethod]
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object ApplyDiscount(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("ApplyDiscount", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            PL_AddToCart pobj = new PL_AddToCart();
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
            pobj.OrderId = requestData.OrderId;
            pobj.OrderNo = requestData.OrderNo;
            pobj.Discount = requestData.Discount;
            pobj.Type = requestData.Type;

            BAL_AddToCartAPI.ApplyDiscount(pobj);
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
                        objResponse.responseMessage = pobj.exceptionMessage;
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

    [WebMethod]
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object GetCartDetails(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("GetCartDetails", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            PL_AddToCart pobj = new PL_AddToCart();
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
            pobj.OrderNo = requestData.OrderNo;           

            BAL_AddToCartAPI.GetCartDetails(pobj);
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
                        objResponse.responseMessage = pobj.exceptionMessage;
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

    [WebMethod]
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object ResetCartDetails(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("ResetCartDetails", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            PL_AddToCart pobj = new PL_AddToCart();
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
            pobj.OrderNo = requestData.OrderNo;

            BAL_AddToCartAPI.ResetCartDetails(pobj);
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
                        objResponse.responseMessage = pobj.exceptionMessage;
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
}
