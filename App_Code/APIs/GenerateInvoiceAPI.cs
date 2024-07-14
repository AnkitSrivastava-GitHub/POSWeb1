using APIsDLLUtility;
using DLL_GenerateInvoice;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;

/// <summary>
/// Summary description for GenerateInvoiceAPI
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class GenerateInvoiceAPI : System.Web.Services.WebService
{

    public GenerateInvoiceAPI()
    {

        API_gZipCompression.fn_gZipCompression();
    }

    [WebMethod]
    [ScriptMethod(UseHttpGet = false, ResponseFormat = ResponseFormat.Json)]
    public object GenerateInvoice(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("GenerateInvoiceAPI", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            PL_GenerateInvoice pobj = new PL_GenerateInvoice();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.OrderId = requestData.OrderId;
            pobj.OrderNo = requestData.OrderNo;
            pobj.Discount = requestData.Discount;
            pobj.CoupanNo = requestData.CoupanNo;
            pobj.CoupanAmt = requestData.CoupanAmount;
            pobj.CustomerId = requestData.CustomerId;
            pobj.PaymentMethod = requestData.PaymentMethod;
            //pobj.TestMode = pobj.LoginId.Substring((pobj.LoginId.IndexOf("@")) + 1);
            BAL_GenerateInvoice.GenerateInvoice(pobj);
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
    public object InvoiceList(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("InvoiceListAPI", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            PL_GenerateInvoice pobj = new PL_GenerateInvoice();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.InvoiceNo = requestData.InvoiceNo;
            pobj.CustomerName = requestData.CustomerName;
            if (requestData.InvoiceFromDate != "")
            {
                pobj.FromDate = Convert.ToDateTime(requestData.InvoiceFromDate);
            }
            if (requestData.InvoiceFromDate != "")
            {
                pobj.ToDate = Convert.ToDateTime(requestData.InvoiceToDate);
            }
            pobj.PageSize = requestData.PageSize;
            pobj.PageIndex = requestData.PageIndex;
            //pobj.TestMode = pobj.LoginId.Substring((pobj.LoginId.IndexOf("@")) + 1);
            BAL_GenerateInvoice.InvoiceList(pobj);
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
    public object InvoiceDetail(requestContainer requestContainer, requestData requestData)
    {
        ResponseContainer objResponse = new ResponseContainer();
        try
        {
            API_Utility.ErrorLog("InvoiceDetailAPI", JsonConvert.SerializeObject(requestContainer) + JsonConvert.SerializeObject(requestData));
            PL_GenerateInvoice pobj = new PL_GenerateInvoice();
            pobj.AccessToken = requestContainer.AccessToken;
            pobj.Hashkey = requestContainer.Hashkey;
            pobj.DeviceId = requestContainer.DeviceId;
            pobj.LatLong = requestContainer.LatLong;
            pobj.AppVersion = requestContainer.AppVersion;
            pobj.RequestSource = requestContainer.RequestSource;
            pobj.LoginId = requestContainer.LoginId;
            pobj.AutoId = requestContainer.AutoId;
            pobj.InvoiceAutoId = requestData.InvoiceAutoId;
            //pobj.TestMode = pobj.LoginId.Substring((pobj.LoginId.IndexOf("@")) + 1);
            BAL_GenerateInvoice.InvoiceDetail(pobj);
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
