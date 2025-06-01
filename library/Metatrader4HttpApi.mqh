//+----------------------------------------------------------------------------+
//|                                                                            |
//| Titlte : MQl4 & MQL5 HTTP API                                              |
//| Enabling HTTP & HTTPS Requests in Live and Backtesting Environment         |
//| Written By: Elijah E. Masanga                                              |  
//| Research Paper:                                                            |
//| DOI:                                                                       |  
//+----------------------------------------------------------------------------+

#import "shell32.dll"
int ShellExecuteW(
    int hwnd,
    string Operation,
    string File,
    string Parameters,
    string Directory,
    int ShowCmd
);
#import

#import "wininet.dll"
int InternetOpenW(
    string sAgent,
    int lAccessType,
    string sProxyName = "",
    string sProxyBypass = "",
    int lFlags = 0
);
int InternetOpenUrlW(
    int hInternetSession,
    string sUrl, 
    string sHeaders = "",
    int lHeadersLength = 0,
    uint lFlags = 0,
    int lContext = 0 
);
int InternetConnectW(
    int hInternet, 
    string lpszServerName, 
    int nServerPort,
    string lpszUsername, 
    string lpszPassword, 
    int dwService, 
    int dwFlags, 
    int dwContext
);
int HttpOpenRequestW(
    int hConnect, 
    string lpszVerb, 
    string lpszObjectName,
    string lpszVersion, 
    string lpszReferer, 
    int lpszAcceptTypes,
    int dwFlags, 
    int dwContext
);
bool HttpSendRequestW(
    int hRequest, 
    string lpszHeaders, 
    int dwHeaderLength,
    uchar &lpOptional[], 
    int dwOptionalLength
);
int InternetReadFile(
    int hFile,
    uchar &sBuffer[],
    int lNumBytesToRead,
    int &lNumberOfBytesRead
);
int InternetCloseHandle(int hInet);
#import

#define INTERNET_FLAG_RELOAD            0x80000000
#define INTERNET_FLAG_NO_CACHE_WRITE    0x04000000
#define INTERNET_FLAG_PRAGMA_NOCACHE    0x00000100
#define INTERNET_FLAG_SECURE            0x00800000

int hSession_IEType;
int hSession_Direct;
int Internet_Open_Type_Preconfig = 0;
int Internet_Open_Type_Direct = 1;

int hSession(bool Direct)
{
    string InternetAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; Q312461)";
    
    if (Direct) 
    { 
        if (hSession_Direct == 0)
            hSession_Direct = InternetOpenW(InternetAgent, Internet_Open_Type_Direct, "0", "0", 0);
        return hSession_Direct; 
    }
    else 
    {
        if (hSession_IEType == 0)
            hSession_IEType = InternetOpenW(InternetAgent, Internet_Open_Type_Preconfig, "0", "0", 0);
        return hSession_IEType; 
    }
}

string httpGET(string strUrl, string params = "")
{
    strUrl += "?" + params;
   
    int handler = hSession(false);
    int response = InternetOpenUrlW(handler, strUrl, NULL, 0,
        INTERNET_FLAG_NO_CACHE_WRITE |
        INTERNET_FLAG_PRAGMA_NOCACHE |
        INTERNET_FLAG_RELOAD, 0);

    if (response == 0) return "";

    uchar ch[100]; 
    string toStr = ""; 
    int dwBytes;

    while (InternetReadFile(response, ch, 100, dwBytes)) 
    {
        if (dwBytes <= 0) break;
        toStr += CharArrayToString(ch, 0, dwBytes);
    }

    InternetCloseHandle(response);
    return toStr;
}


string httpPOST(string host, string path, string data, string contentType = "application/x-www-form-urlencoded", int port = 80, bool useSSL = false, string queryParams = "")
{
    path += "?" + queryParams;
    
    if (useSSL && port == 80) port = 443;

    int hInet = hSession(false);
    if (hInet == 0) return "";

    int hConnect = InternetConnectW(hInet, host, port, NULL, NULL, 3, 0, 0); // 3 = INTERNET_SERVICE_HTTP
    if (hConnect == 0) return "";

    int flags = INTERNET_FLAG_NO_CACHE_WRITE | INTERNET_FLAG_RELOAD | INTERNET_FLAG_PRAGMA_NOCACHE;
    if (useSSL) flags |= INTERNET_FLAG_SECURE;

    int hRequest = HttpOpenRequestW(hConnect, "POST", path, "HTTP/1.1", NULL, 0, flags, 0);
    if (hRequest == 0)
    {
        InternetCloseHandle(hConnect);
        return "";
    }

    string headers = "Content-Type: " + contentType + "\r\n";
    uchar postData[];
    StringToCharArray(data, postData);

    if (!HttpSendRequestW(hRequest, headers, StringLen(headers), postData, ArraySize(postData) - 1)) 
    {
        InternetCloseHandle(hRequest);
        InternetCloseHandle(hConnect);
        return "";
    }

    uchar ch[100]; 
    string toStr = ""; 
    int dwBytes;

    while (InternetReadFile(hRequest, ch, 100, dwBytes)) 
    {
        if (dwBytes <= 0) break;
        toStr += CharArrayToString(ch, 0, dwBytes);
    }

    InternetCloseHandle(hRequest);
    InternetCloseHandle(hConnect);
    return toStr;
}


string httpPOST_JSON(string host, string path, string jsonData, int port = 443, string queryParams = "")
{
    return httpPOST(host, path, jsonData, "application/json", port, true, queryParams);
}

void httpOpen(string strUrl)
{
    Shell32::ShellExecuteW(0, "open", strUrl, "", "", 3);
}
