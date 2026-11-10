if (FRTOS1_xTaskCreate(${name}, (signed portCHAR *)"${name}", configMINIMAL_STACK_SIZE+${size}, NULL, tskIDLE_PRIORITY+${prio}, NULL) != pdPASS) {
  for(;;){} /* error! Out of heap? */
}
${cursor}
