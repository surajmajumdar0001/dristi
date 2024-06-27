// default values of search input component
const defaultSearchValues = {
  individualName: "",
  mobileNumber: "",
  IndividualID: "",
};

//config for tab search sceeen
export const TabSearchconfig = {
  tenantId: "mz",
  moduleName: "commonCampaignUiConfig",
  showTab: true, // setting true will enable tab screen
  TabSearchconfig: [ // all tab config should be added in json array
    {
      label: "Overview",
      type: "search",
      apiDetails: {
        serviceName: "/individual/v1/_search",
        requestParam: {
          tenantId: Digit.ULBService.getCurrentTenantId()
        },
        requestBody: {
          apiOperation: "SEARCH",
          Individual: {
            tenantId: Digit.ULBService.getCurrentTenantId()
          }
        },
        masterName: "commonUiConfig",
        moduleName: "SearchIndividualConfig",
        minParametersForSearchForm: 0,
        tableFormJsonPath: "requestParam",
        filterFormJsonPath: "requestBody.Individual",
        searchFormJsonPath: "requestBody.Individual",
      },
      sections: {
        search: {
          uiConfig: {
            formClassName: "custom-both-clear-search",
            primaryLabel: "ES_COMMON_SEARCH",
            secondaryLabel: "ES_COMMON_CLEAR_SEARCH",
            minReqFields: 0,
            defaultValues: defaultSearchValues, // Set default values for search fields
            fields: [
              {
                label: "Applicant name ",
                isMandatory: false,
                key: "individualName",
                type: "text",
                populators: {
                  name: "individualName",
                  error: "Required",
                  validation: { pattern: /^[A-Za-z]+$/i },
                },
              },
              {
                label: "Phone number",
                isMandatory: false,
                key: "Phone number",
                type: "number",
                disable: false,
                populators: { name: "mobileNumber", error: "sample error message", validation: { min: 0, max: 999999999 } },
              },
              {
                label: "Individual Id ",
                isMandatory: false,
                type: "text",
                disable: false,
                populators: {
                  name: "individualId",
                },
              },
            ],
          },

          show: true,
        },
        searchResult: {
          tenantId: Digit.ULBService.getCurrentTenantId(),
          uiConfig: {
            columns: [
              {
                label: "IndividualID",
                jsonPath: "individualId",
              },
              {
                label: "Name",
                jsonPath: "name.givenName",
              },
              {
                label: "Address",
                jsonPath: "address.locality.code",
              },
            ],

            enableColumnSort: true,
            resultsJsonPath: "Individual",
          },
          show: true,
        },
      },
    },
    {
      label: "Complaints",
      type: "search",
      sections: {
        search: {
          uiConfig: {
            columns: [],
          },
          show: true,
        },
      },
    },
    {
      label: "Hearings",
      type: "search",
      apiDetails: {
        serviceName: "/hearing/v1/search",
        requestParam: {
          tenantId: Digit.ULBService.getCurrentTenantId(),
        },
        requestBody: {
          apiOperation: "SEARCH",
          Individual: {
            tenantId: Digit.ULBService.getCurrentTenantId(),
          },
        },
        masterName: "commonUiConfig",
        moduleName: "SearchIndividualConfig",
        minParametersForSearchForm: 0,
        tableFormJsonPath: "requestParam",
        filterFormJsonPath: "requestBody.Individual",
        searchFormJsonPath: "requestBody.Individual",
      },
      sections: {
        search: {
          uiConfig: {
            formClassName: "custom-both-clear-search",
            primaryLabel: "ES_COMMON_SEARCH",
            secondaryLabel: "ES_COMMON_CLEAR_SEARCH",
            minReqFields: 0,
            defaultValues: defaultSearchValues, // Set default values for search fields
            fields: [
              {
                label: "Applicant name ",
                isMandatory: false,
                key: "individualName",
                type: "text",
                populators: {
                  name: "individualName",
                  error: "Required",
                  validation: { pattern: /^[A-Za-z]+$/i },
                },
              },
              {
                label: "Phone number",
                isMandatory: false,
                key: "Phone number",
                type: "number",
                disable: false,
                populators: { name: "mobileNumber", error: "sample error message", validation: { min: 0, max: 999999999 } },
              },
              {
                label: "Individual Id ",
                isMandatory: false,
                type: "text",
                disable: false,
                populators: {
                  name: "individualId",
                },
              },
            ],
          },

          show: true,
        },
        searchResult: {
          tenantId: Digit.ULBService.getCurrentTenantId(),
          uiConfig: {
            columns: [
              {
                label: "IndividualID",
                jsonPath: "individualId",
              },

              {
                label: "Name",
                jsonPath: "name.givenName",
              },
              {
                label: "Address",
                jsonPath: "address.locality.code",
              },
            ],

            enableColumnSort: true,
            resultsJsonPath: "Individual",
          },
          show: true,
        },
      },
    },
    {
      label: "Orders",
      type: "search",
      apiDetails: {
        serviceName: "/order/order/v1/search",
        requestParam: {
          tenantId: Digit.ULBService.getCurrentTenantId(),
        },
        requestBody: {
          apiOperation: "SEARCH",
          Individual: {
            tenantId: Digit.ULBService.getCurrentTenantId(),
          },
        },
        masterName: "commonUiConfig",
        moduleName: "SearchIndividualConfig",
        minParametersForSearchForm: 0,
        tableFormJsonPath: "requestParam",
        filterFormJsonPath: "requestBody.Individual",
        searchFormJsonPath: "requestBody.Individual",
      },
      sections: {
        search: {
          uiConfig: {
            formClassName: "custom-both-clear-search",
            primaryLabel: "ES_COMMON_SEARCH",
            secondaryLabel: "ES_COMMON_CLEAR_SEARCH",
            minReqFields: 0,
            defaultValues: defaultSearchValues, // Set default values for search fields
            fields: [
              {
                label: "Applicant name ",
                isMandatory: false,
                key: "individualName",
                type: "text",
                populators: {
                  name: "individualName",
                  error: "Required",
                  validation: { pattern: /^[A-Za-z]+$/i },
                },
              },
              {
                label: "Phone number",
                isMandatory: false,
                key: "Phone number",
                type: "number",
                disable: false,
                populators: { name: "mobileNumber", error: "sample error message", validation: { min: 0, max: 999999999 } },
              },
              {
                label: "Individual Id ",
                isMandatory: false,
                type: "text",
                disable: false,
                populators: {
                  name: "individualId",
                },
              },
            ],
          },

          show: true,
        },
        searchResult: {
          tenantId: Digit.ULBService.getCurrentTenantId(),
          uiConfig: {
            columns: [
              {
                label: "Order Type",
                jsonPath: "orderType",
              },

              {
                label: "Order Id",
                jsonPath: "id",
              },
              {
                label: "Stage",
                jsonPath: "",
              },
              {
                label: "Parties",
                jsonPath: "",
              },
              {
                label: "Status",
                jsonPath: "status",
              },
            ],

            enableColumnSort: true,
            resultsJsonPath: "list",
          },
          show: true,
        },
      },
    },
    {
      label: "Submissions",
      type: "search",
      apiDetails: {
        serviceName: "/application/application/v1/search",
        requestParam: {
          tenantId: Digit.ULBService.getCurrentTenantId(),
        },
        requestBody: {
          apiOperation: "SEARCH",
          Individual: {
            tenantId: Digit.ULBService.getCurrentTenantId(),
          },
          criteria: {
            tenantId: Digit.ULBService.getCurrentTenantId(),
          },
        },
        masterName: "commonUiConfig",
        moduleName: "SubmissionConfig",
        minParametersForSearchForm: 0,
        tableFormJsonPath: "requestParam",
        filterFormJsonPath: "requestBody.Individual",
        searchFormJsonPath: "requestBody.Individual",
      },
      sections: {
        search: {
          uiConfig: {
            formClassName: "custom-both-clear-search",
            primaryLabel: "ES_COMMON_SEARCH",
            secondaryLabel: "ES_COMMON_CLEAR_SEARCH",
            minReqFields: 0,
            defaultValues: defaultSearchValues, // Set default values for search fields
            fields: [
              {
                label: "Applicant name ",
                isMandatory: false,
                key: "individualName",
                type: "text",
                populators: {
                  name: "individualName",
                  error: "Required",
                  validation: { pattern: /^[A-Za-z]+$/i },
                },
              },
              {
                label: "Phone number",
                isMandatory: false,
                key: "Phone number",
                type: "number",
                disable: false,
                populators: { name: "mobileNumber", error: "sample error message", validation: { min: 0, max: 999999999 } },
              },
              {
                label: "Individual Id ",
                isMandatory: false,
                type: "text",
                disable: false,
                populators: {
                  name: "individualId",
                },
              },
            ],
          },

          show: true,
        },
        searchResult: {
          tenantId: Digit.ULBService.getCurrentTenantId(),
          uiConfig: {
            columns: [
              {
                label: "Submission Name",
                jsonPath: "applicationType",
              },

              {
                label: "Submission Id",
                jsonPath: "id",
              },
              {
                label: "Stage",
                jsonPath: ""
              },
              {
                label: "Status",
                jsonPath: "status"
              },
              {
                label: "Owner",
                jsonPath: ""
              },
              // {
              //   label: "Document",
              //   jsonPath: "doc",
              //   additionalCustomization: true
              // }
            ],

            enableColumnSort: true,
            resultsJsonPath: "applicationList",
          },
          show: true,
        },
      },
    },
    {
      label: "History",
      type: "search",
      apiDetails: {
        serviceName: "/individual/v1/_search",
        requestParam: {
          tenantId: Digit.ULBService.getCurrentTenantId(),
        },
        requestBody: {
          apiOperation: "SEARCH",
          Individual: {
            tenantId: Digit.ULBService.getCurrentTenantId(),
          },
        },
        masterName: "commonUiConfig",
        moduleName: "SearchIndividualConfig",
        minParametersForSearchForm: 0,
        tableFormJsonPath: "requestParam",
        filterFormJsonPath: "requestBody.Individual",
        searchFormJsonPath: "requestBody.Individual",
      },
      sections: {
        search: {
          uiConfig: {
            formClassName: "custom-both-clear-search",
            primaryLabel: "ES_COMMON_SEARCH",
            secondaryLabel: "ES_COMMON_CLEAR_SEARCH",
            minReqFields: 0,
            defaultValues: defaultSearchValues, // Set default values for search fields
            fields: [
              {
                label: "Applicant name ",
                isMandatory: false,
                key: "individualName",
                type: "text",
                populators: {
                  name: "individualName",
                  error: "Required",
                  validation: { pattern: /^[A-Za-z]+$/i },
                },
              },
              {
                label: "Phone number",
                isMandatory: false,
                key: "Phone number",
                type: "number",
                disable: false,
                populators: { name: "mobileNumber", error: "sample error message", validation: { min: 0, max: 999999999 } },
              },
              {
                label: "Individual Id ",
                isMandatory: false,
                type: "text",
                disable: false,
                populators: {
                  name: "individualId",
                },
              },
            ],
          },

          show: true,
        },
        searchResult: {
          tenantId: Digit.ULBService.getCurrentTenantId(),
          uiConfig: {
            columns: [
              {
                label: "IndividualID",
                jsonPath: "individualId",
              },

              {
                label: "Name",
                jsonPath: "name.givenName",
              },
              {
                label: "Address",
                jsonPath: "address.locality.code",
              },
            ],

            enableColumnSort: true,
            resultsJsonPath: "Individual",
          },
          show: true,
        },
      },
    },
    {
      label: "Parties",
      type: "search",
      apiDetails: {
        serviceName: "/case/case/v1/_search",
        requestParam: {
          tenantId: Digit.ULBService.getCurrentTenantId(),
        },
        requestBody: {
          apiOperation: "SEARCH",
          Individual: {
            tenantId: Digit.ULBService.getCurrentTenantId(),
          },
        },
        masterName: "commonUiConfig",
        moduleName: "PartiesConfig",
        minParametersForSearchForm: 0,
        tableFormJsonPath: "requestParam",
        filterFormJsonPath: "requestBody.Individual",
        searchFormJsonPath: "requestBody.Individual",
      },
      sections: {
        search: {
          uiConfig: {
            formClassName: "custom-both-clear-search",
            primaryLabel: "ES_COMMON_SEARCH",
            secondaryLabel: "ES_COMMON_CLEAR_SEARCH",
            minReqFields: 0,
            defaultValues: defaultSearchValues, // Set default values for search fields
            fields: [
              {
                label: "Applicant name ",
                isMandatory: false,
                key: "individualName",
                type: "text",
                populators: {
                  name: "individualName",
                  error: "Required",
                  validation: { pattern: /^[A-Za-z]+$/i },
                },
              },
              {
                label: "Phone number",
                isMandatory: false,
                key: "Phone number",
                type: "number",
                disable: false,
                populators: { name: "mobileNumber", error: "sample error message", validation: { min: 0, max: 999999999 } },
              },
              {
                label: "Individual Id ",
                isMandatory: false,
                type: "text",
                disable: false,
                populators: {
                  name: "individualId",
                },
              },
            ],
          },

          show: true,
        },
        searchResult: {
          tenantId: Digit.ULBService.getCurrentTenantId(),
          uiConfig: {
            columns: [
              {
                label: "Party Name",
                jsonPath: "name",
              },
              {
                label: "Type",
                jsonPath: "partyType",
              },
              {
                label: "Date Added",
                jsonPath: "auditDetails.createdTime",
                additionalCustomization: true
              },
            ],

            enableColumnSort: true,
            resultsJsonPath: "criteria.responseList.parties",
          },
          show: true,
        },
      },
    },
  ],

};
