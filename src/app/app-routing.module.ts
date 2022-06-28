import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AboutComponent } from './about/about.component';
import { ProfileComponent } from './profile/profile.component';
import { UmbrellaComponent } from './umbrella/umbrella.component';

const routes: Routes = [
  { path: '', redirectTo: '/umbrella', pathMatch: 'full' },
  { path: 'umbrella', component: UmbrellaComponent },
  { path: 'profile', component: ProfileComponent },
  { path: 'about', component: AboutComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {}
