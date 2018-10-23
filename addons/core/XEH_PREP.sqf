// /ACE
PREP_SUB2(ACEInteraction,canTakeRadio);
PREP_SUB2(ACEInteraction,getOwnRadiosChildren);
PREP_SUB2(ACEInteraction,getRadiosChildren);
PREP_SUB2(ACEInteraction,getStereoChildren);
PREP_SUB2(ACEInteraction,getTakeChildren);
PREP_SUB2(ACEInteraction,takeRadio);

// /Events
PREP_SUB(events\handler,addEventHandler);
PREP_SUB(events\handler,fireEventHandlers);
PREP_SUB(events\handler,removeEventHandler);

PREP_SUB(events\keys,onAdditionalLRTangentReleased);
PREP_SUB(events\keys,onAdditionalLRTangentPressed);
PREP_SUB(events\keys,onAdditionalSwTangentReleased);
PREP_SUB(events\keys,onAdditionalSwTangentPressed);
PREP_SUB(events\keys,onLRTangentPressed);
PREP_SUB(events\keys,onLRTangentReleased);
PREP_SUB(events\keys,onLRTangentReleasedHack);
PREP_SUB(events\keys,onSpeakVolumeChangePressed);
PREP_SUB(events\keys,onSpeakVolumeModifierPressed);
PREP_SUB(events\keys,onSpeakVolumeModifierReleased);
PREP_SUB(events\keys,onSwTangentPressed);
PREP_SUB(events\keys,onSwTangentReleased);
PREP_SUB(events\keys,onSwTangentReleasedHack);
PREP_SUB(events\keys,onTangentPressedHack);
PREP_SUB(events\keys,processCuratorKey);
PREP_SUB(events\keys,processLRChannelKeys);
PREP_SUB(events\keys,processLRCycleKeys);
PREP_SUB(events\keys,processLRStereoKeys);
PREP_SUB(events\keys,processSWChannelKeys);
PREP_SUB(events\keys,processSWCycleKeys);
PREP_SUB(events\keys,processSWStereoKeys);

PREP_SUB(events\ui,onSwDialogOpen);
PREP_SUB(events\ui,onLRDialogOpen);
PREP_SUB(events\ui,setVolumeViaDialog);
PREP_SUB(events\ui,setChannelViaDialog);
PREP_SUB(events\ui,updateSWDialogToChannel);
PREP_SUB(events\ui,updateLRDialogToChannel);

PREP_SUB(events,onArsenal);
PREP_SUB(events,onCuratorInterface);
PREP_SUB(events,onMissionEnd);

// /flexiUI
PREP_SUB(flexiUI,copyRadioSettingMenu);
PREP_SUB(flexiUI,lrRadioSubMenu);
PREP_SUB(flexiUI,lrRadioMenu);
PREP_SUB(flexiUI,swRadioSubMenu);
PREP_SUB(flexiUI,swRadioMenu);

// /hint
PREP_SUB(hint,hideHint);
PREP_SUB(hint,inWaterHint);
PREP_SUB(hint,showHint);
PREP_SUB(hint,showRadioInfo);
PREP_SUB(hint,showRadioSpeakers);
PREP_SUB(hint,showRadioVolume);
PREP_SUB(hint,unableToUseHint);

// /plugin
PREP_SUB(plugin,betaTracker); //#TODO remove on release
PREP_SUB(plugin,getTeamSpeakChannelID);
PREP_SUB(plugin,getTeamSpeakChannelName);
PREP_SUB(plugin,getTeamspeakPluginVersion);
PREP_SUB(plugin,getTeamSpeakServerName);
PREP_SUB(plugin,getTeamSpeakServerUID);
PREP_SUB(plugin,isSpeaking);
PREP_SUB(plugin,isTeamSpeakPluginEnabled);
PREP_SUB(plugin,pluginNextDataFrame);
PREP_SUB(plugin,processTangent);
PREP_SUB(plugin,releaseAllTangents);
PREP_SUB(plugin,sendFrequencyInfo);
PREP_SUB(plugin,sendPlayerInfo);
PREP_SUB(plugin,sendPlayerKilled);
PREP_SUB(plugin,sendPluginConfig);
PREP_SUB(plugin,sendSpeakerRadios);
PREP_SUB(plugin,sessionTracker);
PREP_SUB(plugin,setPluginSetting);

// /server
PREP_SUB(server,instanciateRadios);
PREP_SUB(server,instanciateRadiosServer);
PREP_SUB(server,missingModMessage);
PREP_SUB(server,serverInit);

// A
PREP(activeLrRadio);
PREP(activeSwRadio);
// B
PREP(backpackLr);
// C
PREP(calcTerrainInterception);
PREP(canSpeak);
PREP(canUseSWRadio);
PREP(canUseLRRadio);
PREP(canUseDDRadio);
PREP(clientInit);
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
PREP(getVehicleRadios);
// H
PREP(hasRadio);
PREP(hasVehicleRadio);
PREP(haveProgrammator);
PREP(haveDDRadio);
PREP(haveLRRadio);
PREP(haveSWRadio);
// I
PREP(initKeybinds);
PREP(initCBASettings);
PREP(isAbleToUseRadio);
PREP(isBackpackRadio);
PREP(isForcedCurator);
PREP(isPrototypeRadio);
PREP(isRadio);
PREP(isLRRadio);
PREP(isSameRadio);
PREP(isVehicleIsolated);
// L
PREP(loadoutReplaceProcess);
PREP(lrRadiosList);
// O
PREP(objectInterception);
// P
PREP(parseFrequenciesInput);
PREP(preparePositionCoordinates);
PREP(processPlayerPositions);
PREP(processRespawn);
// R
PREP(radioOn);
PREP(radioReplaceProcess);
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
PREP(setSwSpeakers);
PREP(setAdditionalLrStereo);
PREP(setAdditionalSwStereo);
PREP(setAdditionalLrChannel);
PREP(setAdditionalSwChannel);
PREP(setSwRadioCode);
PREP(setLrRadioCode);
PREP(setVoiceVolume);
PREP(setActiveSwRadio);
PREP(setActiveLrRadio);
PREP(setLongRangeRadioFrequency);
PREP(setPersonalRadioFrequency);
PREP(setChannelFrequency);
PREP(setRadioOwner);
PREP(setLrSpeakers);
PREP(settingForceArray);
// U
PREP(updateSpeakVolumeUI);
// V
PREP(vehicleId);
PREP(vehicleIsIsolatedAndInside);
PREP(vehicleLr);

DEPRECATE(fnc_generateSwSettings,fnc_generateSRSettings); //#Depreacted renamed func for SR LR consistency

//#TODO deprecate other Sw functions
