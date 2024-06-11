import React, { useMemo, useState } from "react";
import LocationComponent from "./LocationComponent";
import { ReactComponent as CrossIcon } from "../images/cross.svg";
import Button from "./Button";
import { generateUUID } from "../Utils";

const selectCompMultiConfig = {
  type: "component",
  component: "SelectComponents",
  key: "addressDetails",
  withoutLabel: true,
  populators: {
    inputs: [
      { label: "CS_PIN_LOCATION", type: "LocationSearch", name: ["pincode", "state", "district", "city", "coordinates", "locality"] },
      {
        label: "PINCODE",
        type: "text",
        name: "pincode",
        validation: {
          minlength: 6,
          maxlength: 6,
          patternType: "Pincode",
          pattern: "[0-9]+",
          max: "9999999",
          errMsg: "ADDRESS_PINCODE_INVALID",
          isRequired: true,
          title: "",
        },
        isMandatory: true,
      },
      {
        label: "STATE",
        type: "text",
        name: "state",
        validation: {
          isRequired: true,
          pattern: /^[^{0-9}^\$\"<>?\\\\~!@#$%^()+={}\[\]*,/_:;“”‘’]{1,50}$/i,
          errMsg: "CORE_COMMON_APPLICANT_STATE_INVALID",
          patternType: "Name",
          title: "",
        },
        isMandatory: true,
      },
      {
        label: "DISTRICT",
        type: "text",
        name: "district",
        validation: {
          isRequired: true,
          pattern: /^[^{0-9}^\$\"<>?\\\\~!@#$%^()+={}\[\]*,/_:;“”‘’]{1,50}$/i,
          errMsg: "CORE_COMMON_APPLICANT_DISTRICT_INVALID",
          patternType: "Name",
          title: "",
        },
        isMandatory: true,
      },
      {
        label: "CITY/TOWN",
        type: "text",
        name: "city",
        validation: {
          isRequired: true,
        },
        isMandatory: true,
      },
      {
        label: "ADDRESS",
        type: "text",
        name: "locality",
        validation: {
          isRequired: true,
        },
        isMandatory: true,
      },
    ],
    validation: {},
  },
};

const SelectComponentsMulti = ({ t, config, onSelect, formData, errors }) => {
  const [locationData, setLocationData] = useState([{ id: generateUUID() }]);
  
  const addressLabel = useMemo(() => {
   return formData?.respondentType?.code;
  }, [formData?.respondentType]);

  const handleAdd = () => {
    setLocationData((locationData) => {
      const updatedLocationData = [...(locationData || []), { id: generateUUID() }];
      onSelect(config.key, updatedLocationData);
      return updatedLocationData;
    });
  };

  const handleDeleteLocation = (locationId) => {
    setLocationData((locationData) => {
      const currentFormData = locationData.filter((data) => data.id !== locationId);
      onSelect(config.key, currentFormData);
      return currentFormData;
    });
  };

  const onChange = (key, value, locationId) => {
    setLocationData((locationData) => {
      const locationsCopy = structuredClone(locationData);
      const updatedLocations = locationsCopy.map((data) => (data.id === locationId ? { ...data, addressDetails: value } : data));

      onSelect(config?.key, updatedLocations);
      return updatedLocations;
    });
  };

  return (
    <div>
      {locationData.map((data, index) => (
        <div key={data.id}>
          <div style={{ display: "flex", gap: "4px" }}>
            <b><h1>{` ${addressLabel == "INDIVIDUAL" ? t("CS_RESPONDENT_ADDRESS_DETAIL") : addressLabel == "REPRESENTATIVE" ? t("CS_COMPANY_LOCATION") : t("WITNESS_LOCATION")} ${index + 1}`}</h1></b>
            <span onClick={() => handleDeleteLocation(data.id)} style={locationData.length === 1 ? { display: "none" } : {}}>
              <CrossIcon></CrossIcon>
            </span>
          </div>
          <LocationComponent
            t={t}
            config={selectCompMultiConfig}
            locationFormData={data}
            onLocationSelect={(key, value) => {
              onChange(key, value, data.id);
            }}
            errors={{}}
            mapIndex={data.id}
          ></LocationComponent>
        </div>
      ))}
      <Button
        label={"Add Location"}
        style={{ alignItems: "center" }}
        onButtonClick={() => {
          handleAdd();
        }}
      />
    </div>
  );
};

export default SelectComponentsMulti;