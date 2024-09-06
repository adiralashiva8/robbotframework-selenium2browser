*** Settings ***
Library     String
Library     Browser    strict=${False}


*** Keywords ***
### Alert Keywords
Initiate Wait For Alert Promise
    [Arguments]    ${action}=accept
    ${action}=    Convert To Lower Case    ${action}
    Set Test Variable    ${ALERT_PROMISE}    ${EMPTY}
    ${promise}=    Promise To    Wait For Alert    action=${action}
    Set Test Variable    ${ALERT_PROMISE}    ${promise}

Alert Should Be Present
    [Arguments]    ${text}
    ${alert_text}=    Wait For    ${ALERT_PROMISE}
    Should Contain    ${alert_text}    ${text}

Alert Should Not Be Present
    [Arguments]    ${text}
    TRY
        ${alert_text}=    Wait For    ${ALERT_PROMISE}
        Fail    Alert with message: "${text}" found
    EXCEPT
        No Operation
    END

Handle Alert
    [Documentation]    Keyword should be used before action which triggers alert
    [Arguments]    ${action}=accept
    ${action}=    Convert To Lower Case    ${action}
    Handle Future Dialogs    action=${action}

Input Text Into Alert
    [Documentation]    Keyword should be used before action which triggers alert
    [Arguments]    ${action}=accept    ${text}=${None}
    ${action}=    Convert To Lower Case    ${action}
    Handle Future Dialogs    action=${action}    prompt_input=${text}

### Browser Keywords ###

Switch Browser To Main
    [Arguments]    ${index}=0
    @{ids}=    Get Context Ids
    Switch Context    ${ids}[${index}]

### Checkbox Keywords ###

Select Checkbox
    [Arguments]    ${selector}
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Check Checkbox    ${locator}

Unselect Checkbox
    [Arguments]    ${selector}
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Uncheck Checkbox    ${locator}

Checkbox Should Be Selected
    [Arguments]    ${selector}    ${operator}=equals    ${checked}=${True}
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Get Checkbox State    ${locator}    ${operator}    ${checked}

Checkbox Should Not Be Selected
    [Arguments]    ${selector}    ${operator}=equals    ${checked}=${False}
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Get Checkbox State    ${locator}    ${operator}    ${checked}

Page Should Contain Checkbox
    [Arguments]    ${selector}    ${state}=attached
    Wait Until Element State    ${selector}    ${state}

Page Should Not Contain Checkbox
    [Arguments]    ${selector}    ${state}=detached
    Wait Until Element State    ${selector}    ${state}

### Click Keywords

Click Button
    [Arguments]    ${text}
    Click    text="${text}"

Click Element
    [Arguments]    ${selector}
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Click    ${locator}

Click Link
    [Arguments]    ${text}
    Click    text="${text}"

Double Click Element
    [Arguments]    ${selector}    ${click_count}=2
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Click With Options    ${locator}    clickCount=${click_count}

Open Context Menu
    [Arguments]    ${selector}    ${button}=right
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Click With Options    ${locator}    button=${button}

### Close Browser

Close Window
    [Arguments]    ${page}=CURRENT    ${context}=CURRENT    ${browser}=CURRENT
    Close Page    ${page}    ${context}    ${browser}

Close All Browsers
    Close Browser    ALL

### Dropdown Keywords

Get List Items
    [Arguments]    ${selector}    ${values}=${False}
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    @{options}=    Get Select Options    ${locator}
    IF    ${values}
        @{values}=    Evaluate    [option["value"] for option in @{options}]
    ELSE
        @{values}=    Evaluate    [option["label"] for option in @{options}]
    END
    RETURN    ${values}

Get Selected List Label
    [Arguments]    ${selector}    ${by}=label
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    @{options}=    Get Selected Options    ${locator}    ${by}
    RETURN    ${options}[0]

Get Selected List Labels
    [Arguments]    ${selector}    ${by}=label
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    @{options}=    Get Selected Options    ${locator}    ${by}
    RETURN    @{options}

Get Selected List Value
    [Arguments]    ${selector}    ${by}=value
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    @{options}=    Get Selected Options    ${locator}    ${by}
    RETURN    ${options}[0]

Get Selected List Values
    [Arguments]    ${selector}    ${by}=value
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    @{options}=    Get Selected Options    ${locator}    ${by}
    RETURN    @{options}

Select From List By Index
    [Arguments]    ${selector}    ${value}    ${by}=index
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Select Options By    ${locator}    ${by}    ${value}

Select From List By Label
    [Arguments]    ${selector}    ${value}    ${by}=label
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Select Options By    ${locator}    ${by}    ${value}

Select From List By Value
    [Arguments]    ${selector}    ${value}    ${by}=value
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Select Options By    ${locator}    ${by}    ${value}

Select All From List
    [Arguments]    ${selector}    ${by}=label
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    @{options}=    Get Select Options    ${locator}
    @{values}=    Evaluate    [option["${by}"] for option in @{options}]
    Select Options By    ${locator}    ${by}    @{values}
    Log Many    @{values}

Unselect All From List
    [Arguments]    ${selector}
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Deselect Options    ${locator}

Unselect From List By Index
    [Arguments]    ${selector}    @{indexes}
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    @{options}=    Get Selected Options    ${locator}    index
    Deselect Options    ${locator}
    @{new_values}=    Evaluate    [index for index in @{options} if index not in @{indexes}]
    Select Options By    ${locator}    index    @{new_values}

Unselect From List By Label
    [Arguments]    ${selector}    @{labels}
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    @{options}=    Get Selected Options    ${locator}    label
    Deselect Options    ${locator}
    @{new_values}=    Evaluate    [label for label in @{options} if label not in @{labels}]
    Select Options By    ${locator}    label    @{new_values}

Unselect From List By Value
    [Arguments]    ${selector}    @{values}
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    @{options}=    Get Selected Options    ${locator}    value
    Deselect Options    ${locator}
    @{new_values}=    Evaluate    [value for value in @{options} if value not in @{values}]
    Select Options By    ${locator}    value    @{new_values}

Page Should Contain List
    [Arguments]    ${selector}    ${state}=attached
    Wait Until Element State    ${selector}    ${state}

Page Should Not Contain List
    [Arguments]    ${selector}    ${state}=detached
    Wait Until Element State    ${selector}    ${state}

List Selection Should Be
    [Arguments]    ${selector}    @{values}
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Get Selected Options    ${locator}    label    contains    @{values}

List Should Have No Selections
    [Documentation]    Uses label by default
    [Arguments]    ${selector}    ${by}=label
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Get Selected Options    ${locator}    ${by}    validate    len(${by}) == 0

### Element Keywords

Element Attribute Value Should Be
    [Arguments]    ${selector}    ${attribute}    ${expected}
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Get Attribute    ${locator}    ${attribute}    contains    ${expected}

### Focus Keywords ###

Set Focus To Element
    [Arguments]    ${selector}
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Focus    ${locator}

### Frame Keywords ###

### Javascript ###

Execute Javascript
    [Arguments]    ${function}
    Evaluate JavaScript    ${None}    () => {${function}}

### Location Keywords ###

Get Location
    ${url}=    Get Url
    RETURN    ${url}

Location Should Contain
    [Arguments]    ${partial_url}    ${operator}=contains
    Get Url    ${operator}    ${partial_url}

Wait Until Location Contains
    [Arguments]    ${partial_url}    ${operator}=contains
    Wait For Condition    Url    ${operator}    ${partial_url}

Wait Until Location Does Not Contain
    [Arguments]    ${partial_url}    ${operator}=not contains
    Wait For Condition    Url    ${operator}    ${partial_url}

Wait Until Location Is
    [Arguments]    ${full_url}    ${operator}=equals
    Wait For Condition    Url    ${operator}    ${full_url}

Wait Until Location Is Not
    [Arguments]    ${full_url}    ${operator}=not equals
    Wait For Condition    Url    ${operator}    ${full_url}

### Screenshot ###

Capture Page Screenshot
    [Arguments]    ${type}=EMBED
    Take Screenshot    ${type}

### Text keywords

Input Text
    [Arguments]    ${selector}    ${value}
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Fill Text    ${locator}    ${value}

Input Password
    [Arguments]    ${selector}    ${value}
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Fill Secret    ${locator}    ${value}

Clear Element Text
    [Arguments]    ${selector}
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Clear Text    ${locator}

Textfield Value Should Be
    [Arguments]    ${selector}    ${value}    ${operator}=equals
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Get Text    ${locator}    ${operator}    ${value}

Textfield Should Contain
    [Arguments]    ${selector}    ${value}    ${operator}=contains
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Get Text    ${locator}    ${operator}    ${value}

Get Value
    [Arguments]    ${selector}
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    ${text}=    Get Text    ${locator}
    RETURN    ${text}

Textarea Value Should Be
    [Arguments]    ${selector}    ${value}    ${operator}=equals
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Get Text    ${locator}    ${operator}    ${value}

Textarea Should Contain
    [Arguments]    ${selector}    ${value}    ${operator}=contains
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Get Text    ${locator}    ${operator}    ${value}

Page Should Contain Textfield
    [Arguments]    ${selector}    ${state}=attached
    Wait Until Element State    ${selector}    ${state}

Page Should Not Contain Textfield
    [Arguments]    ${selector}    ${state}=detached
    Wait Until Element State    ${selector}    ${state}

### Wait Keywords

Wait Until Page Contains
    [Arguments]    ${text}    ${operator}=contains
    Wait For Condition    Text    css=body    ${operator}    ${text}

Wait Until Page Does Not Contain
    [Arguments]    ${text}    ${operator}=not contains
    Wait For Condition    Text    css=body    ${operator}    ${text}

Wait Until Element Is Enabled
    [Arguments]    ${selector}    ${state}=enabled
    Wait Until Element State    ${selector}    ${state}

Wait Until Element Is Visible
    [Arguments]    ${selector}    ${state}=visible
    Wait Until Element State    ${selector}    ${state}

Wait Until Element Is Not Visible
    [Arguments]    ${selector}    ${state}=hidden
    Wait Until Element State    ${selector}    ${state}

Wait Until Element State
    [Arguments]    ${selector}    ${state}
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Wait For Elements State    ${locator}    ${state}

Wait Until Element Contains
    [Arguments]    ${selector}    ${value}    ${operator}=contains
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Wait For Condition    Text    ${locator}    ${operator}    ${value}

Wait Until Element Does Not Contain
    [Arguments]    ${selector}    ${value}    ${operator}=not contains
    ${locator}=    Adjust Locator To Browser Library    ${selector}
    Wait For Condition    Text    ${locator}    ${operator}    ${value}

Wait Until Page Contains Element
    [Arguments]    ${selector}    ${state}=attached
    Wait Until Element State    ${selector}    ${state}

Wait Until Page Does Not Contain Element
    [Arguments]    ${selector}    ${state}=detached
    Wait Until Element State    ${selector}    ${state}

### re-usable keyword

Adjust Locator To Browser Library
    [Arguments]    ${selector}
    # check if selector is either xpath, css or text
    ${locator}=    Replace String    ${selector}    :    =    1
    RETURN    ${locator}
