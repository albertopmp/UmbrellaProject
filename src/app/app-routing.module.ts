import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { UmbrellaComponent } from './umbrella/umbrella.component';

const routes: Routes = [{ path: 'umbrella', component: UmbrellaComponent }];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {}
