  $FsrmQuotaObject = new-object -com FSRM.FsrmReportManager
   $FsrmQuotaObject|gm
  $3123 = $FsrmQuotaObject.EnumReportJobs()
  $ee= $3123|%{$_.EnumReports()}
  $ee|fl
  $3123|%{$_ |gm}
  $3123|%{$_.task}
  $FsrmQuotaObject|gm
  Cancel                   Method     void Cancel ()                                   
Commit                   Method     void Commit ()                                   
CreateReport             Method     IFsrmReport CreateReport (_FsrmReportType)       
Delete                   Method     void Delete ()                                   
EnumReports              Method     IFsrmCollection EnumReports ()                   
Run                      Method     void Run (_FsrmReportGenerationContext)          
WaitForCompletion        Method     bool WaitForCompletion (int)                     
Description              Property   string Description () {get} {set}                
Formats                  Property   SAFEARRAY(Variant) Formats () {get} {set}        
id                       Property   GUID id () {get}                                 
LastError                Property   string LastError () {get}                        
LastGeneratedInDirectory Property   string LastGeneratedInDirectory () {get}         
LastRun                  Property   Date LastRun () {get}                            
MailTo                   Property   string MailTo () {get} {set}                     
NamespaceRoots           Property   SAFEARRAY(Variant) NamespaceRoots () {get} {set} 
RunningStatus            Property   _FsrmReportRunningStatus RunningStatus () {get}  
Task                     Property   string Task () {get} {set}                       
