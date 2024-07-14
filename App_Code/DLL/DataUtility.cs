using System.Data.SqlClient;
using System.Configuration;
using System;
using System.Web.UI.WebControls;
using System.Data;


public class DataUtility
{
    
   
    public static string gridPagging(GridView GridView1, DataTable dt)
    {
        string lblcount = "";
        int totalrows = 0;
        GridView1.DataSource = dt;

        GridView1.DataBind();
        try { totalrows = dt.Rows.Count; }
        catch { totalrows = 0; }
        if (totalrows > 0)
        {
            if (GridView1.AllowPaging)
            {
                //if(GridView1.PageIndex>0
                int i = ((GridView1.PageIndex) * GridView1.PageSize) + 1;
                lblcount = i + "-" + (i + GridView1.Rows.Count - 1) + " of " + totalrows;
            }
            else
            {
                lblcount = "All " + totalrows + " records";
            }
        }
        else lblcount = "No Recordes";
        return lblcount;
    }
    //this function Convert to Encode your Password
    public string EncodePasswordToBase64(string password)
    {
        try
        {
            byte[] encData_byte = new byte[password.Length];
            encData_byte = System.Text.Encoding.UTF8.GetBytes(password);
            string encodedData = Convert.ToBase64String(encData_byte);
            return encodedData;
        }
        catch (Exception ex)
        {
            throw new Exception("Error in base64Encode" + ex.Message);
        }
    }
    //this function Convert to Decode your Password
    public string DecodeFrom64(string encodedData)
    {
        System.Text.UTF8Encoding encoder = new System.Text.UTF8Encoding();
        System.Text.Decoder utf8Decode = encoder.GetDecoder();
        byte[] todecode_byte = Convert.FromBase64String(encodedData);
        int charCount = utf8Decode.GetCharCount(todecode_byte, 0, todecode_byte.Length);
        char[] decoded_char = new char[charCount];
        utf8Decode.GetChars(todecode_byte, 0, todecode_byte.Length, decoded_char, 0);
        string result = new String(decoded_char);
        return result;
    }
    public object stringFuntion(object str)
    {
        string value = str.ToString().ToLower();
        char[] array = value.ToCharArray();
        // Handle the first letter in the string.
        if (array.Length >= 1)
        {
            if (char.IsLower(array[0]))
            {
                array[0] = char.ToUpper(array[0]);
            }
        }
        // Scan through the letters, checking for spaces.
        // ... Uppercase the lowercase letters following spaces.
        for (int i = 1; i < array.Length; i++)
        {
            if (array[i - 1] == ' ')
            {
                if (char.IsLower(array[i]))
                {
                    array[i] = char.ToUpper(array[i]);
                }
            }
        }
        return (new string(array));
    }
   
}