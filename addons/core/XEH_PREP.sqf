//#TODO sort after subfolders and then after alphabet

PREP_SUB(server,serverInit);
PREP(clientInit);

// A
PREP(activeLrRadio);
PREP(activeSwRadio);
PREP_SUB(events\handler,addEventHandler);
PREP(addRadiosToACE);
PREP(addStereoToACE);
PREP(addTakeToACE);
// B
PREP(backpackLr);
// C
PREP(calcTerrainInterception);
PREP(canSpeak);
PREP(canTakeRadio);
PREP(canUseSWRadio);
PREP(canUseLRRadio);
PREP(canUseDDRadio);
PREP_SUB(flexiUI,copyRadioSettingMenu);
PREP(copySettings);
PREP(currentDirection);
PREP(currentLRFrequency);
PREP(currentSWFrequency);
PREP(currentUnit);
// D
PREP(defaultPositionCoordinates);
// E
PREP(eyeDepth);
// F
PREP_SUB(events\handler,fireEventHandlers);
PREP(forceSpectator);
// G
PREP(generateLrSettings);
PREP(generateSRSettings);
PREP(generateFrequencies);
PREP(getVehicleSide);
PREP(getSwRadioCode);
PREP(getLrRadioCode);
PREP(getSwChannel);
PREP(getLrChannel);
PREP(getSwStereo);
PREP(getSwFrequency);
PREP(getLrFrequency);
PREP(getLrStereo);
PREP(getSwVolume);
PREP(getLrVolume);
PREP(getSwSettings);
PREP(getLrSettings);
PREP(getNearPlayers);
PREP_SUB(plugin,getTeamspeakPluginVersion);
PREP_SUB(plugin,getTeamSpeakServerName);
PREP_SUB(plugin,getTeamSpeakChannelName);
PREP(getVehicleConfigProperty);
PREP(getWeaponConfigProperty);
PREP(getCopilot);
PREP(getLrRadioProperty);
PREP(getChannelFrequency);
PREP(getRadioItems);
PREP(getSideRadio);
PREP(getTransmittingDistanceMultiplicator);
PREP(getAdditionalLrStereo);
PREP(getAdditionalSwStereo);
PREP(getAdditionalLrChannel);
PREP(getAdditionalSwChannel);
PREP(getCurrentSwStereo);
PREP(getCurrentLrStereo);
PREP(getDefaultRadioClasses);
PREP(getDefaultRadioSettings);
PREP(getRadioOwner);
PREP(getSwSpeakers);
PREP(getLrSpeakers);
// H
PREP(hasRadio);
PREP(hasVehicleRadio);
PREP(haveProgrammator);
PREP_SUB(hint,hideHint);
PREP(haveDDRadio);
PREP(haveLRRadio);
PREP(haveSWRadio);
// I
PREP(initKeybinds);
PREP_SUB(server,instanciateRadios);
PREP_SUB(hint,inWaterHint);
PREP(isAbleToUseRadio);
PREP(isBackpackRadio);
PREP(isForcedCurator);
PREP(isPrototypeRadio);
PREP(isRadio);
PREP(isLRRadio);
PREP(isSameRadio);
PREP_SUB(plugin,isSpeaking);
PREP_SUB(plugin,isTeamSpeakPluginEnabled);
PREP(isTurnedOut);
PREP(isVehicleIsolated);
// L
PREP(loadoutReplaceProcess);
PREP_SUB(flexiUI,lrRadioSubMenu);
PREP_SUB(flexiUI,lrRadioMenu);
PREP(lrRadiosList);
// O
PREP(objectInterception);
PREP_SUB(events\keys,onAdditionalSwTangentReleased);
PREP_SUB(events\keys,onAdditionalSwTangentPressed);
PREP_SUB(events\keys,onAdditionalLRTangentReleased);
PREP_SUB(events\keys,onAdditionalLRTangentPressed);
PREP_SUB(events,onArsenal);
PREP_SUB(events,onCuratorInterface);
PREP_SUB(events\keys,onLRTangentPressed);
PREP_SUB(events\keys,onLRTangentReleased);
PREP_SUB(events\keys,onLRTangentReleasedHack);
PREP_SUB(events,onMissionEnd);
PREP_SUB(events\keys,onSwTangentPressed);
PREP_SUB(events\keys,onSwTangentReleased);
PREP_SUB(events\keys,onTangentPressedHack);
PREP_SUB(events\keys,onSwTangentReleasedHack);
PREP_SUB(events\keys,onSpeakVolumeChangePressed);
PREP_SUB(events\keys,onSpeakVolumeModifierPressed);
PREP_SUB(events\keys,onSpeakVolumeModifierReleased);
PREP_SUB(events\ui,onSwDialogOpen);
PREP_SUB(events\ui,onLRDialogOpen);
PREP_SUB(hint,onGroundHint);
// P
PREP(parseFrequenciesInput);
PREP(preparePositionCoordinates);
PREP_SUB(events\keys,processSWChannelKeys);
PREP_SUB(events\keys,processSWCycleKeys);
PREP_SUB(events\keys,processSWStereoKeys);
PREP_SUB(events\keys,processLRChannelKeys);
PREP_SUB(events\keys,processLRCycleKeys);
PREP_SUB(events\keys,processLRStereoKeys);
PREP(processPlayerPositions);
PREP_SUB(events\keys,processCuratorKey);
PREP_SUB(plugin,processTangent);
PREP(processRespawn);
// R
PREP(radioOn);
PREP_SUB(events\handler,removeEventHandler);
PREP(radioReplaceProcess);
PREP_SUB(plugin,releaseAllTangents);
PREP(requestRadios);
PREP(radioToRequestCount);
PREP(radiosList);
PREP(radiosListSorted);
// S
PREP(setSwSettings);
PREP(setLrSettings);
PREP(setSwStereo);
PREP(setLrChannel);
PREP(setSwChannel);
PREP(setSwVolume);
PREP(setLrVolume);
PREP(setSwFrequency);
PREP(setLrFrequency);
PREP(setLrStereo);
PREP(setHeadsetLowered);
PREP_SUB(plugin,sendFrequencyInfo);
PREP_SUB(plugin,sendPlayerInfo);
PREP_SUB(plugin,sendPlayerKilled);
PREP_SUB(plugin,sendPluginConfig);
PREP_SUB(plugin,sendSpeakerRadios);
PREP(setSwSpeakers);
PREP(setAdditionalLrStereo);
PREP(setAdditionalSwStereo);
PREP(setAdditionalLrChannel);
PREP(setAdditionalSwChannel);
PREP_SUB(hint,showHint);
PREP_SUB(hint,showRadioInfo);
PREP_SUB(hint,showRadioSpeakers);
PREP(setSwRadioCode);
PREP(setLrRadioCode);
PREP(setVoiceVolume);
PREP(setActiveSwRadio);
PREP(setActiveLrRadio);
PREP(setLongRangeRadioFrequency);
PREP(setPersonalRadioFrequency);
PREP_SUB(plugin,setPluginSetting);
PREP_SUB(plugin,pluginNextDataFrame);
PREP_SUB(flexiUI,swRadioSubMenu);
PREP_SUB(flexiUI,swRadioMenu);
PREP_SUB(hint,showRadioVolume);
PREP(setChannelFrequency);
PREP(setRadioOwner);
PREP(setLrSpeakers);
PREP_SUB(plugin,sessionTracker);
PREP_SUB(plugin,betaTracker); //#TODO remove on release
PREP_SUB(events\ui,setVolumeViaDialog);
PREP_SUB(events\ui,setChannelViaDialog);
PREP(settingForceArray);
// T
PREP(takeRadio);
// U
PREP_SUB(events\ui,updateSWDialogToChannel);
PREP_SUB(events\ui,updateLRDialogToChannel);
PREP_SUB(hint,unableToUseHint);
PREP(updateSpeakVolumeUI);
// V
PREP(vehicleId);
PREP(vehicleIsIsolatedAndInside);
PREP(vehicleLr);




DEPRECATE(fnc_generateSwSettings,fnc_generateSRSettings); //#Depreacted renamed func for SR LR consistency

//#TODO deprecate other Sw functions
