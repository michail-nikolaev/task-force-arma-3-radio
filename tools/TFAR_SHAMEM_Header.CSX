
<Structures>
  <Structure Name="TFARSHAMEMHeader" AutoFill="0" AutoCreate="1" DefaultHex="0" AutoDestroy="0" DoNotSaveLocal="0" AutoCreateStructsize="4096">
    <Elements>
      <Element Offset="0" Vartype="4 Bytes" Bytesize="4" Description="Pagesize" DisplayMethod="Unsigned Integer" BackgroundColor="80000005"/>
      <Element Offset="4" Vartype="4 Bytes" Bytesize="4" Description="nextFreeAsyncMessage" DisplayMethod="Unsigned Integer" BackgroundColor="80000005"/>
      <Element Offset="8" Vartype="8 Bytes" Bytesize="8" Description="lastGameTick" DisplayMethod="Hexadecimal" BackgroundColor="80000005"/>
      <Element Offset="16" Vartype="8 Bytes" Bytesize="8" Description="lastPluginTick" DisplayMethod="Hexadecimal" BackgroundColor="80000005"/>
      <Element Offset="24" Vartype="Byte" Bytesize="1" Description="configNeedsRefresh" DisplayMethod="Unsigned Integer" BackgroundColor="80000005"/>
    </Elements>
  </Structure>
</Structures>