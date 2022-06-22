import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MaterialModule } from 'src/material.module';
import { HeaderComponent } from './header/header.component';
import { UmbrellaComponent } from './umbrella/umbrella.component';
import { ConfirmSnackbarComponent } from './confirm-snackbar/confirm-snackbar.component';

@NgModule({
  declarations: [AppComponent, HeaderComponent, UmbrellaComponent, ConfirmSnackbarComponent],
  imports: [BrowserModule, AppRoutingModule, BrowserAnimationsModule, MaterialModule],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule {}
