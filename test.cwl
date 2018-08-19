class: CommandLineTool
cwlVersion: v1.0
inputs:
- id: b
  type: string
  inputBinding: { position: 4 }
- id: c
  type: string
  inputBinding: { position: 5 }
- id: a
  type: string
  inputBinding: { position: 1 }
baseCommand: echo
arguments:
- arg0
- valueFrom: "arg2"
  position: 3
- valueFrom: "arg1"
  position: 2
outputs: []
