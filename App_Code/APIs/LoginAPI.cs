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

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]
public class LoginAPI : System.Web.Services.WebService
{
    public LoginAPI()
    {
        API_gZipCompression.fn_gZipCompression();
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object Login(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("Login", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            PL_APILogin pobj = new PL_APILogin();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.UserName = requestData.UserName;
            pobj.Password = requestData.Password;
            BL_APILogin.Login(pobj);
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
    public object GetCurrencyList(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("GetCurrencyList", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            PL_APILogin pobj = new PL_APILogin();
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
            //pobj.TestMode = pobj.LoginId.Substring((pobj.LoginId.IndexOf("@")) + 1);
            BL_APILogin.GetCurrencyList(pobj);
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
    public object ProceedCurrencyTerminal(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("ProceedCurrencyTerminal", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            PL_APILogin pobj = new PL_APILogin();
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
            pobj.LoginAutoId = requestData.LoginAutoId;
            pobj.BalanceStatus = requestData.BalanceStatus;
            pobj.OpeningBalance = requestData.OpeningBalance;
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
            BL_APILogin.ProceedCurrencyTerminal(pobj);
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

}
