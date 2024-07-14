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


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]
public class GetDropdownList : System.Web.Services.WebService
{
    public GetDropdownList()
    {
        API_gZipCompression.fn_gZipCompression();
    }
    [WebMethod]
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object DropdownList(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("DropdownList", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_DropdownList.PL_DropdownList pobj = new global::DLL_DropdownList.PL_DropdownList();
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
            pobj.DDLString = requestData.DDLString;
            //pobj.TestMode = pobj.LoginId.Substring((pobj.LoginId.IndexOf("@")) + 1);
            global::DLL_DropdownList.BAL_DropdownList.GetDropdownList(pobj);
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
    public object StatusList(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("DropdownList", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_DropdownList.PL_DropdownList pobj = new global::DLL_DropdownList.PL_DropdownList();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;

            global::DLL_DropdownList.BAL_DropdownList.GetDropdownList(pobj);
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
    public object PayoutDropdownList(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("PayoutDropdownList", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            global::DLL_DropdownList.PL_DropdownList pobj = new global::DLL_DropdownList.PL_DropdownList();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.StoreId = requestData.StoreId;

            global::DLL_DropdownList.BAL_DropdownList.PayoutTypeList(pobj);
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


