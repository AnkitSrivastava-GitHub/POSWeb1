using System;
using System.Collections.Generic;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for PropertyUtilityAbstract
/// </summary>
public abstract class PropertyUtilityAbstract
{
    // User Activity log related.

    private string who; public string Who { get { return who; } set { who = value; } }
    private DateTime when; public DateTime When { get { return when; } set { when = value; } }
    private string action;

    public string Action
    {
        get { return action; }
        set { action = value; }
    }
    private string actionDesc; public string ActionDesc { get { return actionDesc; } set { actionDesc = value; } }
    private string refType; public string RefType { get { return refType; } set { refType = value; } }
    private string refId; public string RefId { get { return refId; } set { refId = value; } }

    // Operation Code.
    private int opCode; public int OpCode { get { return opCode; } set { opCode = value; } }

    // For handling exception details.
    private bool isException; public bool IsException { get { return isException; } set { isException = value; } }
    private string exceptionMessage; public string ExceptionMessage { get { return exceptionMessage; } set { exceptionMessage = value; } }

    // For data handling.
    private DataTable dt; public DataTable Dt { get { return dt; } set { dt = value; } }

    public PropertyUtilityAbstract()
    {
        when = Convert.ToDateTime("01/01/2012");
    }
    bool searchAll;
    int rowcount;

    public int Rowcount
    {
        get { return rowcount; }
        set { rowcount = value; }
    }
    public bool SearchAll
    {
        get { return searchAll; }
        set { searchAll = value; }
    }
}