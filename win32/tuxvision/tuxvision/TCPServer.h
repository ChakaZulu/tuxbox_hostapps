
typedef enum CVCRStates 
{
    CMD_VCR_UNKNOWN = 0,
    CMD_VCR_RECORD  = 1,
    CMD_VCR_STOP    = 2,
    CMD_VCR_PAUSE   = 3,
    CMD_VCR_RESUME  = 4
}CVCRCommand;

enum CVCRDevices
{
    DEVICE_VCR,
    DEVICE_SERVER
};

struct externalCommand                        // command wird an externen server gesendet
{
    unsigned char      messageType;           // egal
    unsigned char      version;               // momentan 1
    unsigned int       command;               // siehe externalcommands
    unsigned __int64   epgID;                 // may be zero
    unsigned int       onidsid;               // may be zero
};
